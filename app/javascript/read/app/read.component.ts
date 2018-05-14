import { Component, OnInit, AfterViewChecked, HostListener, ViewChild, ViewChildren, ElementRef, QueryList } from '@angular/core';
import { WorksService } from './works.services';
import { CustomFunctions } from '../custom_functions';
import { Gridify } from '../gridify';
import readHTML from './templates/read.html';
import { Work } from './work';
import { User } from './user';


@Component({
  selector: 'read',
  template: readHTML,
  providers: [WorksService, CustomFunctions, Gridify]
})

export class ReadComponent implements OnInit {
  works: Work[];
  old_works: Work[];
  selected_work: Work = null;
  user_choosen: User = null;
  count_works_loadet: number;
  numOfTimes: number = 1;
  @ViewChild("read_grid") read_grid: ElementRef;
  @ViewChildren("work_item") DOM_works: QueryList<any>;

  constructor(
    private service: WorksService,
    private custFuncs: CustomFunctions,
    private gridify: Gridify
  ) { } 

  @HostListener("window:scroll", []) onWindowScroll() {
    const verticalOffset = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0;
    const window_height = window.outerHeight;
    var grid_height = this.read_grid.nativeElement.clientHeight;
    if ((verticalOffset + window_height) > grid_height) {
      this.service.moreWorks(this.works.length);
    }
  }

  ngOnInit() {
    // How many works should be loaded? Based on the size of the window
    this.count_works_loadet = this.service.worksToLoad(this.read_grid.nativeElement.clientWidth, window.outerHeight)
    this.service.getWorks(this.count_works_loadet).subscribe(works => this.works = works);
  }

  ngAfterViewChecked() { // It's run multiple times - i don't know how to fix it yet
    if (this.numOfTimes == 4 && !this.selected_work) { // Rendered 10 times if i don't do this - and it is rendered in the background when work is shown
      this.setGrid();
    }
    this.numOfTimes += 1;
  }


  showText(work) {
    document.querySelector('body').style.overflow = "hidden";
    this.selected_work = work;
  }

  closeText(scroll_up = false) {
    var body = document.querySelector('body');
    body.style.overflow = "auto";
    if (scroll_up )  {
      window.scrollTo(0, 0);
    }
    this.selected_work = null;
  }

  userWorks(user_id, username) {
    this.fadeOutNotUsersWorks(user_id); //debugger;
    // this.remove_works = true;
    this.old_works = this.works;
    this.user_choosen = {name: username, id: user_id};
    this.service.getUsersWorks(user_id).subscribe(
      works => this.works = works,
      error => console.log(error),
      () => {
       let works = this.works;
       this.DOM_works.changes.subscribe( // IT'S WORKING!
         () => { this.setGrid() }
       )
      }
    );
  }

  fadeOutNotUsersWorks(user_id) {
    var dom_works = this.DOM_works;
    dom_works.forEach(work => {
      var dom_work = work.nativeElement;
      if (!dom_work.classList.contains(`user-id-${user_id}`)) {
        dom_work.classList.add('high-opacity');
        dom_work.addEventListener('mouseenter', function() {
          dom_works.forEach( new_work => {
            new_work.nativeElement.classList.remove('high-opacity');
          })
        });
      }
    });

  }

  setGrid() {
    let read_grid = document.querySelector('.read-grid');
    this.gridify.createGrid(read_grid);
  }

  showAllWorks(event) {
    this.works = this.old_works;
    this.DOM_works.changes.subscribe(
      () => { this.setGrid() }
    )
  }

  checkHighlight(work_id) {
  }
}
