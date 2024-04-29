import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { FormGroup, FormControl, ReactiveFormsModule } from '@angular/forms';
import { MatRadioModule } from '@angular/material/radio';
import { MatSliderModule } from '@angular/material/slider';
import { SimulationService } from './services/simulation.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [
    RouterOutlet,
    ReactiveFormsModule,
    MatRadioModule,
    MatSliderModule
  ],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  constituencySimulations: any[] = [];
  votingSimulations: any[] = [];
  simulations: any[] = [];
  calculationMethods: any[] = [
    { id: 1, name: 'D\'Hondt' },
    { id: 2, name: 'Sainte-Laguë' },
    { id: 3, name: 'Hare-Niemeyer' }
  ];

  partyResults: any[] = [];

  form: FormGroup;

  constructor(private simulationService: SimulationService) {
    this.form = new FormGroup({
      simulationId: new FormControl(1),
      calculationId: new FormControl({ value: 1, disabled: true }),
      threshold: new FormControl(5)
    });

    this.form.valueChanges.subscribe(value => {
      this.calculateVotes(value);
    });
  }

  ngOnInit() {
    this.simulationService.getConstituencies().subscribe(constituencySimulations => {
      this.constituencySimulations = constituencySimulations;
      // console.log(this.constituencySimulations);
      this.simulations = this.constituencySimulations
        .map(constituency => ({
          id: constituency.simulationId,
          name: constituency.simulationName
        }))
        .filter((simulation, index, self) =>
          index === self.findIndex((t) => (
            t.id === simulation.id && t.name === simulation.name
          ))
        );
      // console.log(this.simulations);
    });

    this.simulationService.getVotes().subscribe(votingSimulations => {
      this.votingSimulations = votingSimulations;
      // console.log(this.votingSimulations);
      this.calculateVotes(this.form.value);
    });
  }

  calculateVotes(formValue: any) {
    //calculate by dhondt now
    // console.log(formValue);
    //filter voting simulations by simulationId and threshold
    let votingSimulations = this.votingSimulations.filter(votingSimulation => {
      return votingSimulation.simulationId === formValue.simulationId && formValue.threshold <= votingSimulation.votesPercentage;
    });
    // console.log(votingSimulations);
    let votes: any[] = [];
    votingSimulations.forEach(votingSimulation => {
      //fetch number of mandates for this constituency
      let constituencySimulation = this.constituencySimulations.find(constituencySimulation => constituencySimulation.simulationId === votingSimulation.simulationId && constituencySimulation.constituencyId === votingSimulation.constituencyId);
      // console.log(constituencySimulation);
      //calculate number of votes for each mandate by dhont method

      for (let i = 1; i <= constituencySimulation.numberOfMandates; i++) {
        votes.push({
          constituencyNumber: votingSimulation.constituencyNumber,
          party: votingSimulation.partyName,
          selected: false,
          total: Math.round(votingSimulation.votes / i),
        });
      }
    });
    // console.log(votes);
    // console.log(this.constituenciesFiltered);

    //votes contain all votes for all mandates, now we need to select top 14 votes for each constituency and mark votes as selected
    let constituencies = Array.from(new Set(votes.map(vote => vote.constituencyNumber)));
    constituencies.forEach(constituencyNumber => {
      let votesForConstituency = votes.filter(vote => vote.constituencyNumber === constituencyNumber);
      let sortedVotes = votesForConstituency.sort((a, b) => b.total - a.total);
      let constituencySimulation = this.constituenciesFiltered.find(constituencySimulation => constituencySimulation.constituencyNumber === constituencyNumber);
      let topVotes = sortedVotes.slice(0, constituencySimulation.numberOfMandates);
      topVotes.forEach(topVote => {
        let voteIndex = votes.findIndex(vote => vote === topVote);
        if (voteIndex !== -1) {
          votes[voteIndex].selected = true;
        }
      });
    });
    // console.log(votes);

    //now create array of parties and count selected votes for each constituency
    let parties = Array.from(new Set(votes.map(vote => vote.party)));
    let result: any[] = [];

    constituencies.forEach(constituency => {
      parties.forEach(party => {
        let partyVotes = votes.filter(vote => vote.party === party && vote.constituencyNumber === constituency);
        let partyVotesCount = partyVotes.filter(vote => vote.selected).length;
        result.push({
          constituency: constituency,
          party: party,
          mandates: partyVotesCount
        });
      });
    });
    // console.log(result);

    this.partyResults = parties.map(party => {
      let partyConstituencies = constituencies.map(constituency => {
        let partyVotes = votes.filter(vote => vote.party === party && vote.constituencyNumber === constituency);
        let partyVotesCount = partyVotes.filter(vote => vote.selected).length;
        return {
          constituency: constituency,
          mandates: partyVotesCount
        };
      });
    
      let totalMandates = partyConstituencies.reduce((total, current) => total + current.mandates, 0);
    
      return {
        party: party,
        mandates: partyConstituencies,
        total: totalMandates
      };
    });
    this.partyResults.sort((a, b) => b.total - a.total);
    // console.log(this.partyResults);
  }

  get constituenciesFiltered() {
    return this.constituencySimulations.filter(constituency => constituency.simulationId === this.form.value.simulationId);
  }

}
