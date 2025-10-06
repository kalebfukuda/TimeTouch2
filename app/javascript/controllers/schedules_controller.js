import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="schedules"
export default class extends Controller {
  connect() {
  }

  validateAndSubmit(event) {
    event.preventDefault();
    const form = event.target.form;
    const date = form.querySelector('input[name="schedule[date]"]').value;
    const selectedEmployees = form.querySelectorAll('input[name="schedule[employee_ids][]"]:checked');

    if (!date) {
      alert("Por favor, selecione uma data.");
      return;
    }

    if (selectedEmployees.length === 0) {
      alert("Por favor, selecione pelo menos um funcionário.");
      return;
    }

    form.submit();
  }
}
