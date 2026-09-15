import { Service } from '@angular/core';

@Service()
export class Calculator {
  percentage(value: number, total: number): number {
    if (total === 0) return 0;
    return Math.round((value / total) * 100);
  }
}
