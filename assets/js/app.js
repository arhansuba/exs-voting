import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";

// Initialize LiveSocket
const csrfToken = document.querySelector("meta[name=\'csrf-token\']").content;
const liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken }
});
liveSocket.connect();

// Blockchain interaction
class BlockchainVoting {
  constructor() {
    this.initializeVoting();
  }

  initializeVoting() {
    const voteForm = document.getElementById("vote-form");
    if (voteForm) {
      voteForm.addEventListener("submit", async (event) => {
        event.preventDefault();
        await this.submitVote(new FormData(voteForm));
      });
    }

    const voteOptions = document.querySelectorAll(".vote-option");
    voteOptions.forEach(option => {
      option.addEventListener("click", () => {
        voteOptions.forEach(opt => opt.classList.remove("selected"));
        option.classList.add("selected");
      });
    });
  }

  async submitVote(formData) {
    try {
      const submitButton = document.querySelector("button[type=submit]");
      submitButton.disabled = true;
      submitButton.classList.add("loading");

      const response = await fetch("/vote", {
        method: "POST",
        body: formData
      });

      if (!response.ok) {
        throw new Error("Failed to submit vote");
      }

      this.showToast("Vote submitted successfully!", "success");
    } catch (error) {
      this.showToast("Failed to submit vote: " + error.message, "error");
    } finally {
      submitButton.disabled = false;
      submitButton.classList.remove("loading");
    }
  }

  showToast(message, type = "success") {
    const toast = document.createElement("div");
    toast.className = `toast ${type} animate-fade-in`;
    toast.textContent = message;
    document.body.appendChild(toast);

    setTimeout(() => {
      toast.classList.add("opacity-0");
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }
}

// Initialize when DOM is loaded
document.addEventListener("DOMContentLoaded", () => {
  window.blockchainVoting = new BlockchainVoting();
});

