import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, catchError, of } from 'rxjs';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class SimulationService {

  constructor(private http: HttpClient) { }

  private simulationsUrl = `${environment.apiURL}/Simulation`;

  getConstituencies(): Observable<any[]>{
    return this.http.get<any[]>(`${this.simulationsUrl}/Constituencies/`);
  }
  
  getVotes(): Observable<any[]>{
    return this.http.get<any[]>(`${this.simulationsUrl}/Votes/`);
  }
}
