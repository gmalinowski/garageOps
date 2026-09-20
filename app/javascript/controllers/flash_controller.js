import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="notification"
export default class extends Controller {
  static targets = ["progress"]
  static values = {
    duration: { type: Number, default: 8000 }
  }
  paused = false
  connect() {
    if (this.durationValue <= 0) return;
    this.startAnimation();
  }

  disconnect() {
    this.progressBarAnimation?.cancel();
    this.boxAnimation?.cancel();
  }

  dismiss() {
    this.element.remove();
  }

  toggle() {
    if (this.paused) {
      this.progressBarAnimation?.play();
      this.boxAnimation?.play();
    } else {
      this.progressBarAnimation?.pause();
      this.boxAnimation?.pause();
    }
    this.paused = !this.paused;
  }


  startAnimation() {
    const fadeDuration = Math.min(200, this.durationValue)
    const fadeStart = 1 - fadeDuration / this.durationValue;

    this.boxAnimation = this.element.animate(
      [
        {opacity: 1, offset: 0},
        {opacity: 1, transform: "translateY(0)", offset: fadeStart},
        {opacity: 0, transform: "translateY(5rem)", offset: 1}
      ],
        {
          duration: this.durationValue,
          easing: "linear",
          fill: "forwards"
        }
    );

    this.progressBarAnimation = this.progressTarget.animate(
        [
          {transform: "scaleX(1)"},
          {transform: "scaleX(0)"},
        ],
        {
          duration: this.durationValue - fadeDuration,
          easing: "linear",
          fill: "forwards"
        }
    );

    this.boxAnimation.onfinish = () => this.dismiss();
  }
}
