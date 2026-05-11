import { LightningElement } from 'lwc';
import healthcarelogoIcon from '@salesforce/resourceUrl/Health360logo';
import bottomImg1 from '@salesforce/resourceUrl/bottomImg1';
import bottomImg2 from '@salesforce/resourceUrl/bottomImg2';
import bottomImg3 from '@salesforce/resourceUrl/bottomImg3';
import bottomImg4 from '@salesforce/resourceUrl/bottomImg4';
import KasettiNewLogo from '@salesforce/resourceUrl/KasettiNewLogo';

export default class ImageComponent extends LightningElement {
    // Property to store the image URL
    healthcare360logoIconUrl;
    bottomImg1;
    bottomImg2;
    bottomImg3;
    bottomImg4;
    KasettiNewLogo;

    // Lifecycle hook invoked when the component is connected to the DOM
    connectedCallback() {
        // Load the image URL using the resource URL
        this.healthcare360logoIconUrl = healthcarelogoIcon;
        this.bottomImg1 = bottomImg1;
        this.bottomImg2 = bottomImg2;
        this.bottomImg3 = bottomImg3;
        this.bottomImg4 = bottomImg4;
        this.KasettiNewLogo = KasettiNewLogo;
    }

    redirectToTechKasetti() {
        // window.location.href = 'https://techkasetti.com/';
        window.open('https://techkasetti.com' , '_blank');
    }
    
}