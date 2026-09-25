import { Component, inject, signal } from '@angular/core';
import { form, FormField, required, email } from '@angular/forms/signals';
import { LoginData } from './models/login-data';
import { Auth } from './services/auth';

@Component({
  selector: 'app-login',
  imports: [FormField],
  templateUrl: './login.html',
  styleUrl: './login.css',
})
export class Login {
  private auth = inject(Auth);

  loginModel = signal<LoginData>({ email: '', password: '' });

  loginForm = form(this.loginModel, (schemaPath) => {
    required(schemaPath.email, { message: 'Email is required' });
    email(schemaPath.email, { message: 'Enter a valid email address' });
    required(schemaPath.password, { message: 'Password is required' });
  });

  isSubmitting = signal(false);
  errorMessage = signal<string | null>(null);

  onSubmit(event: Event) {
    event.preventDefault();
    this.isSubmitting.set(true);
    this.errorMessage.set(null);

    this.auth.login(this.loginModel()).subscribe({
      next: () => {
        this.isSubmitting.set(false);
        // e.g. redirect to the dashboard here
      },
      error: () => {
        this.isSubmitting.set(false);
        this.errorMessage.set('Invalid email or password.');
      },
    });
  }
}
