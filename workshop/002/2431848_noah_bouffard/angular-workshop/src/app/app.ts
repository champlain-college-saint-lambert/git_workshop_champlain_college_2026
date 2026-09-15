import { Component } from '@angular/core';
import { Greeting } from './features/greeting/greeting';
import { Login } from './features/login/login';

@Component({
  selector: 'app-root',
  imports: [Greeting, Login],
  templateUrl: './app.html',
  styleUrl: './app.css',
})
export class App {}
