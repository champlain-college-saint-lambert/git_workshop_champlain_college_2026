import { Component, inject, signal, computed } from '@angular/core';
import { Calculator } from '../../shared/services/calculator';
import { Todo } from './models/todo';

@Component({
  selector: 'app-greeting',
  templateUrl: './greeting.html',
  styleUrl: './greeting.css',
})
export class Greeting {
  private calculator = inject(Calculator);

  name = 'Angular Workshop';
  showTodos = signal(true);

  todos = signal<Todo[]>([
    { label: 'Set up the project', done: true },
    { label: 'Build a component', done: true },
    { label: 'Learn signals', done: false },
    { label: 'Learn signal forms', done: false },
  ]);

  completedCount = computed(
    () => this.todos().filter((t) => t.done).length
  );

  totalCount = computed(() => this.todos().length);

  // The service handles the arithmetic — Greeting just asks for the result
  completionPercent = computed(() =>
    this.calculator.percentage(this.completedCount(), this.totalCount())
  );

  toggleTodos() {
    this.showTodos.update((value) => !value);
  }

  toggleDone(index: number) {
    this.todos.update((list) =>
      list.map((todo, i) => (i === index ? { ...todo, done: !todo.done } : todo))
    );
  }
}
