import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

const subjectColors = {
  "労働基準法": "#3b82f6",
  "労働安全衛生法": "#60a5fa",
  "労働者災害補償保険法": "#ef4444",
  "雇用保険法": "#f59e0b",
  "健康保険法": "#10b981",
  "国民年金法": "#6366f1",
  "厚生年金保険法": "#8b5cf6",
  // TODO: 他の科目も必要あれば追加
}

export default class extends Controller {
  static values = { data: Object }

  connect() {
    const ctx = this.element.getContext('2d')

    const labels = Object.keys(this.dataValue);
    const colors = labels.map(label => subjectColors[label] || "#9ca3af");

    new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: labels,
        datasets: [{
          data: Object.values(this.dataValue),
          backgroundColor: colors,
          borderWidth: 2,
          borderColor: '#ffffff'
        }]
      },
      options: {
        plugins: {
          legend: { position: 'bottom' }
        },
        cutout: '70%'
      }
    })
  }
}