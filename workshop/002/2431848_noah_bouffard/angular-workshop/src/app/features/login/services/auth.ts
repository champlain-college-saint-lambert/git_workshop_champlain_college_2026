import { Service, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { LoginData } from '../models/login-data';

interface LoginResponse {
  token: string;
}

@Service()
export class Auth {
  private http = inject(HttpClient);

  login(credentials: LoginData) {
    return this.http.post<LoginResponse>(
      'https://reqres.in/api/login',
      credentials
    );
  }
}
