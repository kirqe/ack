import { Controller } from "stimulus";
import Pickr from '@simonwep/pickr';
import '@simonwep/pickr/dist/themes/nano.min.css'; 

export default class extends Controller {
  static targets = ["picker", "wrapper"]

  initialize() {
    this.theme = ""
  }
  
  connect() { 
    this._setTheme()
    const pickr = Pickr.create({
      el: this.pickerTarget,
      theme: 'nano',
      default: localStorage.getItem("accent") || "rgba(59, 130, 246, 1)",
      swatches: [
        'rgba(239, 68, 68, 1)',
        'rgba(245, 158, 11, 1)',
        'rgba(249, 115, 22, 1)',              
        'rgba(16, 185, 129, 1)',  
        'rgba(59, 130, 246, 1)',
        'rgba(99, 102, 241, 1)',
        'rgba(139, 92, 246, 1)',

        'rgba(239, 68, 68, 0.9)',
        'rgba(245, 158, 11, 0.9)',
        'rgba(249, 115, 22, 0.9)',  
        'rgba(16, 185, 129, 0.9)',              
        'rgba(59, 130, 246, 0.9)',
        'rgba(99, 102, 241, 0.9)',      
        'rgba(139, 92, 246, 0.9)',
        
        'rgba(6, 182, 212, 1)',
        'rgba(236, 72, 153, 1)',
        'rgba(20, 184, 166, 1)',

        'rgba(34, 197, 94, 1)',
        'rgba(14, 165, 233, 1)',
        'rgba(168, 85, 247, 1)',
        'rgba(120, 113, 108, 1)',
        'rgba(6, 182, 212, 0.9)',  
        'rgba(236, 72, 153, 0.9)',
        'rgba(20, 184, 166, 0.9)',        
      
        'rgba(34, 197, 94, 0.9)',        
        'rgba(14, 165, 233, 0.9)',        
        'rgba(168, 85, 247, 0.9)',
        'rgba(120, 113, 108, 0.9)'
      ],

      components: {
        // Main components
        preview: true,
        opacity: true,
        hue: true,

        // Input / output Options
        interaction: {
          hex: true,
          rgba: true,

          input: true,
        }
      }
    })

    pickr.on('change', (color, source, instance) => {
      let accent = color.toRGBA().toString(3)            
      let accentLight = accent.replace(/[^,]+(?=\))/, '0.5')
      let accentLighter = accent.replace(/[^,]+(?=\))/, '0.3')
      let accentLightest = accent.replace(/[^,]+(?=\))/, '0.03')

      this.theme = `:root { 
        --accent: ${accent}; 
        --accent-light: ${accentLight}; 
        --accent-lighter: ${accentLighter}; 
        --accent-lightest: ${accentLightest}; 
      }`


      document.getElementById("theme").innerHTML = this.theme
      localStorage.setItem("theme", this.theme)
      localStorage.setItem("accent", accent)
      pickr.applyColor()
    });
    
  }

  teardown() {
    console.log("td")
    this.wrapperTarget.innerHTML = "<div data-theme-target=\"picker\"></div>"
  }

  _setTheme() {
    this.theme = localStorage.getItem("theme")

    if (this.theme !== null) {
      document.getElementById("theme").innerHTML = this.theme
    }
  }
}

