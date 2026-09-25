import { HttpInterceptorFn } from '@angular/common/http';
import { environment } from '../../../environments/environment';

export const apiPrefixInterceptor: HttpInterceptorFn = (req, next) => {
  const isRelative = !/^https?:\/\//i.test(req.url);

  if (isRelative) {
    req = req.clone({ url: `${environment.apiUrl}${req.url}` });
  }

  return next(req);
};
