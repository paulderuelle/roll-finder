import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

// Connects to data-controller="chatroom-subscription"
export default class extends Controller {
  static targets = ["messages"];
  static values = { chatroomId: Number, userId: Number };

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "ChatroomChannel", id: this.chatroomIdValue },
      { received: data => this.#insertMessagesAndScrollDown(data) }
    )
    console.log(`Subscribed to the chatroom with the id ${this.chatroomIdValue}`);
  }

  #buildMessage(data) {
    if (data.user_id === this.userIdValue) {
      return `<div class="message me">${data.message}</div>`;
    } else {
      return `<div class="message you">${data.message}</div>`;
    }
  }

  #insertMessagesAndScrollDown(data) {
    this.messagesTarget.insertAdjacentHTML("beforeend", this.#buildMessage(data));
    this.messagesTarget.scrollTo(0, this.messagesTarget.scrollHeight)
  }

  resetForm(event) {
    event.target.reset();
  }

  disconnect() {
    console.log("Unsubscribed from the chatroom")
    this.channel.unsubscribe()
  }
}
