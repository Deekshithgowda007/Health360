import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import getHospitals from '@salesforce/apex/PatientPortalController.getHospitals';
import getBranches from '@salesforce/apex/PatientPortalController.getBranches';
import getSpecialties from '@salesforce/apex/PatientPortalController.getSpecialties';
import getDoctors from '@salesforce/apex/PatientPortalController.getDoctors';
import getDoctorDetail from '@salesforce/apex/PatientPortalController.getDoctorDetail';
import getDoctorSchedules from '@salesforce/apex/PatientPortalController.getDoctorSchedules';
import lookupPatient from '@salesforce/apex/PatientPortalController.lookupPatient';
import registerPatient from '@salesforce/apex/PatientPortalController.registerPatient';
import getPatientAppointments from '@salesforce/apex/PatientPortalController.getPatientAppointments';
import sendEmailOtp from '@salesforce/apex/DoctorAppointmentController.sendOTP';
import sendPhoneOtp from '@salesforce/apex/DoctorAppointmentController.sendOTPs';

const DEFAULT_APPOINTMENTS = {
    upcoming: [],
    history: []
};

export default class PatientPortalShell extends LightningElement {
    @api portalTitle = 'Patient Appointment Portal';
    @api portalSubtitle = 'Sign in, choose a specialty, pick a nearby branch, and book with the right doctor.';
    @api singleHospitalMode = false;
    @api defaultHospitalId = '';
    @api defaultHospitalName = '';

    @track hospitals = [];
    @track branches = [];
    @track specialties = [];
    @track doctors = [];
    @track schedules = [];
    @track appointments = DEFAULT_APPOINTMENTS;

    @track registration = {
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        street: '',
        city: '',
        state: '',
        country: '',
        postalCode: '',
        company: 'Patient Portal'
    };

    authMode = 'login';
    loginIdentifier = '';
    enteredOtp = '';
    generatedOtp = '';
    authMessage = '';
    otpPending = false;
    isBusy = false;
    showAppointments = false;

    selectedHospitalId = '';
    selectedBranchId = '';
    selectedSpecialtyId = '';
    sortBy = 'recommended';
    doctorSearch = '';

    pendingPatient = null;
    currentPatient = null;
    selectedDoctor = null;
    selectedHospitalName = '';

    connectedCallback() {
        this.initializePortal();
    }

    async initializePortal() {
        this.isBusy = true;
        try {
            const hospitals = await getHospitals();
            this.hospitals = (hospitals || []).map((hospital) => ({
                ...hospital
            }));

            const fixedHospital = this.resolveFixedHospital();
            if (fixedHospital) {
                this.selectedHospitalId = fixedHospital.id;
                this.selectedHospitalName = fixedHospital.name;
                await this.loadBranchContext();
            } else if (this.hospitals.length === 1) {
                this.selectedHospitalId = this.hospitals[0].id;
                this.selectedHospitalName = this.hospitals[0].name;
                await this.loadBranchContext();
            }
        } catch (error) {
            this.showError('We could not load the hospital directory.', error);
        } finally {
            this.isBusy = false;
        }
    }

    get isLoginMode() {
        return this.authMode === 'login';
    }

    get loginTabClass() {
        return this.authMode === 'login' ? 'tab-button active' : 'tab-button';
    }

    get registerTabClass() {
        return this.authMode === 'register' ? 'tab-button active' : 'tab-button';
    }

    get branchesDisabled() {
        return !this.selectedHospitalId || this.branches.length === 0;
    }

    get showHospitalSelector() {
        return !this.isSingleHospitalMode;
    }

    get isSingleHospitalMode() {
        return this.normalizeBoolean(this.singleHospitalMode);
    }

    get canChooseSpecialty() {
        return !!this.selectedHospitalId && !!this.currentPatient;
    }

    get canChooseBranch() {
        return !!this.selectedHospitalId && !!this.selectedSpecialtyId && !!this.currentPatient;
    }

    get canShowDoctorsStep() {
        return !!this.selectedHospitalId && !!this.selectedSpecialtyId && !!this.selectedBranchId && !!this.currentPatient;
    }

    get portalContextLabel() {
        if (this.selectedHospitalName) {
            return `${this.selectedHospitalName} Patient Journey`;
        }
        return 'Hospital Patient Journey';
    }

    get selectedSpecialtyName() {
        const selectedSpecialty = (this.specialties || []).find((specialty) => specialty.id === this.selectedSpecialtyId);
        return selectedSpecialty ? selectedSpecialty.name : 'Choose specialty';
    }

    get selectedBranchName() {
        const selectedBranch = (this.branches || []).find((branch) => branch.id === this.selectedBranchId);
        return selectedBranch ? selectedBranch.name : 'Choose branch';
    }

    get currentStep() {
        if (!this.currentPatient) {
            return 1;
        }
        if (!this.selectedSpecialtyId) {
            return 2;
        }
        if (!this.selectedBranchId) {
            return 3;
        }
        return 4;
    }

    get stepItems() {
        return [
            this.buildStep('1', 'Sign in', 'Identify the patient', this.currentStep >= 1, this.currentStep === 1),
            this.buildStep('2', 'Specialty', 'Choose care area', this.currentStep >= 2, this.currentStep === 2),
            this.buildStep('3', 'Location', 'Pick the nearest branch', this.currentStep >= 3, this.currentStep === 3),
            this.buildStep('4', 'Doctor', 'Compare and continue', this.currentStep >= 4, this.currentStep === 4)
        ];
    }

    get specialtyClearDisabled() {
        return !this.selectedSpecialtyId;
    }

    get hasDoctors() {
        return this.doctors.length > 0;
    }

    get hasSchedules() {
        return this.schedules.length > 0;
    }

    get hasUpcomingAppointments() {
        return this.appointments?.upcoming?.length > 0;
    }

    get hasHistoricalAppointments() {
        return this.appointments?.history?.length > 0;
    }

    get hospitalCountLabel() {
        return `${this.hospitals.length}`;
    }

    get branchCountLabel() {
        return `${this.branches.length}`;
    }

    get doctorCountLabel() {
        return `${this.doctors.length} doctors`;
    }

    switchAuthMode(event) {
        this.authMode = event.currentTarget.dataset.mode;
        this.authMessage = '';
        this.otpPending = false;
        this.enteredOtp = '';
        this.generatedOtp = '';
    }

    handleLoginIdentifierChange(event) {
        this.loginIdentifier = event.target.value;
    }

    handleOtpChange(event) {
        this.enteredOtp = event.target.value;
    }

    handleRegistrationChange(event) {
        const field = event.target.dataset.field;
        this.registration = {
            ...this.registration,
            [field]: event.target.value
        };
    }

    async handleSendOtp() {
        if (!this.loginIdentifier) {
            this.authMessage = 'Enter the patient email address or mobile number first.';
            return;
        }

        this.isBusy = true;
        try {
            const patient = await lookupPatient({ identifier: this.loginIdentifier });
            if (!patient) {
                this.authMessage = 'No patient profile was found. Please register first.';
                this.authMode = 'register';
                if (this.looksLikeEmail(this.loginIdentifier)) {
                    this.registration = {
                        ...this.registration,
                        email: this.loginIdentifier
                    };
                } else {
                    this.registration = {
                        ...this.registration,
                        phone: this.loginIdentifier
                    };
                }
                return;
            }

            this.pendingPatient = patient;
            this.generatedOtp = `${Math.floor(100000 + Math.random() * 900000)}`;
            this.otpPending = true;
            this.enteredOtp = '';

            if (this.looksLikeEmail(this.loginIdentifier)) {
                await sendEmailOtp({ recordId: patient.id, otp: this.generatedOtp });
            } else {
                await sendPhoneOtp({ recordId: patient.id, otp: this.generatedOtp });
            }

            this.authMessage = `OTP sent to ${this.maskIdentifier(this.loginIdentifier)}.`;
        } catch (error) {
            this.showError('We could not start sign-in for this patient.', error);
        } finally {
            this.isBusy = false;
        }
    }

    async handleVerifyOtp() {
        if (!this.otpPending) {
            this.authMessage = 'Send the OTP first.';
            return;
        }

        if (this.enteredOtp !== this.generatedOtp) {
            this.authMessage = 'The OTP does not match. Please try again.';
            return;
        }

        this.currentPatient = this.pendingPatient;
        this.pendingPatient = null;
        this.otpPending = false;
        this.authMessage = `Signed in as ${this.currentPatient.name}.`;
        await this.loadAppointments();
        this.showSuccess('Patient signed in', 'The patient profile is ready for booking.');
    }

    async handleRegister() {
        if (!this.registration.firstName || !this.registration.lastName || !this.registration.email || !this.registration.phone) {
            this.authMessage = 'First name, last name, email, and phone are required.';
            return;
        }

        this.isBusy = true;
        try {
            const patient = await registerPatient({ request: this.registration });
            this.currentPatient = patient;
            this.authMessage = `Patient profile created for ${patient.name}.`;
            await this.loadAppointments();
            this.showSuccess('Patient profile created', 'Registration is complete and the patient can continue.');
        } catch (error) {
            this.showError('We could not create the patient profile.', error);
        } finally {
            this.isBusy = false;
        }
    }

    handleLogout() {
        this.currentPatient = null;
        this.pendingPatient = null;
        this.generatedOtp = '';
        this.enteredOtp = '';
        this.loginIdentifier = '';
        this.otpPending = false;
        this.authMessage = 'Patient session cleared.';
        this.appointments = DEFAULT_APPOINTMENTS;
        this.showAppointments = false;
    }

    async handleHospitalChange(event) {
        this.selectedHospitalId = event.target.value;
        const selectedHospital = this.hospitals.find((hospital) => hospital.id === this.selectedHospitalId);
        this.selectedHospitalName = selectedHospital ? selectedHospital.name : '';
        this.selectedBranchId = '';
        this.selectedSpecialtyId = '';
        this.selectedDoctor = null;
        this.schedules = [];
        await this.loadBranchContext();
    }

    async handleBranchChange(event) {
        this.selectedBranchId = event.target.value;
        this.decorateBranches();
        this.selectedDoctor = null;
        this.schedules = [];
        await this.loadDoctors();
    }

    async handleBranchCardSelect(event) {
        this.selectedBranchId = event.currentTarget.dataset.id;
        this.decorateBranches();
        await this.loadDoctors();
    }

    async handleSpecialtySelect(event) {
        this.selectedSpecialtyId = event.currentTarget.dataset.id;
        this.decorateSpecialties();
        this.selectedBranchId = '';
        this.decorateBranches();
        await this.loadDoctors();
    }

    async clearSpecialtyFilter() {
        this.selectedSpecialtyId = '';
        this.decorateSpecialties();
        this.selectedBranchId = '';
        this.decorateBranches();
        await this.loadDoctors();
    }

    handleSearchChange(event) {
        this.doctorSearch = event.target.value;
        this.loadDoctors();
    }

    handleSortChange(event) {
        this.sortBy = event.target.value;
        this.loadDoctors();
    }

    async handleDoctorSelect(event) {
        const doctorId = event.currentTarget.dataset.doctorId;
        const branchId = event.currentTarget.dataset.branchId;

        this.isBusy = true;
        try {
            const [detail, schedules] = await Promise.all([
                getDoctorDetail({ doctorId, branchId }),
                getDoctorSchedules({ doctorId, branchId })
            ]);

            this.selectedDoctor = this.normalizeDoctorDetail(detail);
            this.schedules = (schedules || []).map((schedule, index) => ({
                ...schedule,
                key: `${schedule.dayOfWeek}-${schedule.startTime}-${index}`
            }));
            this.showAppointments = false;
            this.scrollToSelector('.detail-shell');
        } catch (error) {
            this.showError('We could not load the doctor details.', error);
        } finally {
            this.isBusy = false;
        }
    }

    showAppointmentsView = async () => {
        this.showAppointments = true;
        if (this.currentPatient) {
            await this.loadAppointments();
        }
        this.scrollToSelector('.appointments-shell');
    };

    scrollToDiscovery = () => {
        this.scrollToSelector('#discovery');
    };

    async loadBranchContext() {
        if (!this.selectedHospitalId) {
            this.branches = [];
            this.specialties = [];
            this.doctors = [];
            return;
        }

        this.isBusy = true;
        try {
            this.branches = (await getBranches({ hospitalId: this.selectedHospitalId }) || []).map((branch) => ({
                ...branch,
                cardClass: branch.id === this.selectedBranchId ? 'branch-choice active' : 'branch-choice'
            }));
            await this.loadSpecialtiesAndDoctors();
        } catch (error) {
            this.showError('We could not load the branches for this hospital.', error);
        } finally {
            this.isBusy = false;
        }
    }

    async loadSpecialtiesAndDoctors() {
        this.isBusy = true;
        try {
            const specialties = await getSpecialties({
                hospitalId: this.selectedHospitalId,
                branchId: this.selectedBranchId
            });
            this.specialties = (specialties || []).map((specialty) => ({
                ...specialty,
                cardClass: specialty.id === this.selectedSpecialtyId ? 'specialty-card active' : 'specialty-card'
            }));

            await this.loadDoctors();
        } catch (error) {
            this.showError('We could not load the specialty directory.', error);
        } finally {
            this.isBusy = false;
        }
    }

    async loadDoctors() {
        if (!this.selectedHospitalId || !this.selectedSpecialtyId || !this.selectedBranchId) {
            this.doctors = [];
            return;
        }

        try {
            const doctors = await getDoctors({
                hospitalId: this.selectedHospitalId,
                branchId: this.selectedBranchId,
                specialtyId: this.selectedSpecialtyId,
                searchTerm: this.doctorSearch,
                sortBy: this.sortBy
            });

            this.doctors = (doctors || []).map((doctor) => this.normalizeDoctorCard(doctor));
        } catch (error) {
            this.showError('We could not load doctors for the selected filters.', error);
        }
    }

    async loadAppointments() {
        if (!this.currentPatient?.id) {
            this.appointments = DEFAULT_APPOINTMENTS;
            return;
        }

        try {
            this.appointments = await getPatientAppointments({ patientId: this.currentPatient.id });
        } catch (error) {
            this.showError('We could not load patient appointments.', error);
        }
    }

    normalizeDoctorCard(doctor) {
        return {
            ...doctor,
            cardKey: `${doctor.doctorId}-${doctor.branchId}`,
            initials: this.getInitials(doctor.doctorName),
            shortOverview: doctor.overview ? doctor.overview.slice(0, 150) : 'Profile details will appear here when the practitioner overview is maintained.',
            consultationMode: doctor.consultationMode || 'Consultation details pending'
        };
    }

    normalizeDoctorDetail(detail) {
        if (!detail) {
            return null;
        }

        return {
            ...detail,
            initials: this.getInitials(detail.doctorName),
            branchCount: detail.branches ? detail.branches.length : 0,
            specialtyList: detail.specialties?.join(' - ') || 'Specialty details pending',
            overviewText: detail.overview || 'The practitioner overview will appear here once the record is enriched.',
            consultationMode: detail.consultationMode || 'Consultation details pending',
            hasExpertise: (detail.expertise || []).length > 0,
            hasAwards: (detail.awards || []).length > 0
        };
    }

    decorateSpecialties() {
        this.specialties = (this.specialties || []).map((specialty) => ({
            ...specialty,
            cardClass: specialty.id === this.selectedSpecialtyId ? 'specialty-card active' : 'specialty-card'
        }));
    }

    decorateBranches() {
        this.branches = (this.branches || []).map((branch) => ({
            ...branch,
            cardClass: branch.id === this.selectedBranchId ? 'branch-choice active' : 'branch-choice'
        }));
    }

    looksLikeEmail(value) {
        return value && value.includes('@');
    }

    maskIdentifier(value) {
        if (!value) {
            return '';
        }

        if (this.looksLikeEmail(value)) {
            const [name, domain] = value.split('@');
            return `${name.slice(0, 2)}***@${domain}`;
        }

        return `******${value.slice(-4)}`;
    }

    getInitials(name) {
        if (!name) {
            return 'DR';
        }

        return name
            .split(' ')
            .filter(Boolean)
            .slice(0, 2)
            .map((part) => part[0].toUpperCase())
            .join('');
    }

    resolveFixedHospital() {
        if (!this.isSingleHospitalMode || !this.hospitals.length) {
            return null;
        }

        let hospital = null;
        if (this.defaultHospitalId) {
            hospital = this.hospitals.find((item) => item.id === this.defaultHospitalId);
        }

        if (!hospital && this.defaultHospitalName) {
            const normalizedDefaultName = this.defaultHospitalName.toLowerCase().trim();
            hospital = this.hospitals.find((item) => item.name && item.name.toLowerCase().trim() === normalizedDefaultName);
        }

        return hospital || this.hospitals[0];
    }

    buildStep(index, title, description, completed, active) {
        let cssClass = 'step-card';
        if (active) {
            cssClass += ' active';
        } else if (completed) {
            cssClass += ' complete';
        }

        return {
            index,
            title,
            description,
            cssClass
        };
    }

    normalizeBoolean(value) {
        if (typeof value === 'string') {
            return value === 'true';
        }
        return !!value;
    }

    scrollToSelector(selector) {
        window.setTimeout(() => {
            const target = this.template.querySelector(selector);
            if (target) {
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        }, 0);
    }

    showSuccess(title, message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant: 'success'
            })
        );
    }

    showError(title, error) {
        const message = error?.body?.message || error?.message || 'Unexpected error';
        this.authMessage = message;
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant: 'error'
            })
        );
    }
}
