import { Injectable } from '@angular/core';
import { Http, Response } from '@angular/http';
import { Observable } from 'rxjs';
import { Work } from './work';
import { map } from 'rxjs/operators';

@Injectable()

export class WorksService {
  constructor(private http: Http) {}

  extractData(res: Response) {
    return res.json();
  }

  getWorks(): Observable<Work[]> {
    return this.http.get("/laes.json").pipe(map(this.extractData));
  } 
}