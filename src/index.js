import angular from 'angular'

const app=angular.module('app',[])

app.directive('myApp',()=>{
  return {
    restrict:'E',
    template: `<todo-form></todo-form>`
  }
})

class TodoForm{
  constructor(){
    this.data=[]
    this.text=''
  }
  keypress($event){
    if($event.keyCode===13&&this.text!==''){
      this.data.push({checked:false, text:this.text})
      this.text=''
    }
  }
}

app.directive('todoForm',()=>{
  return {
    restrict:'E',
    bindToController:{text:'='},
    scope:{},
    template:
    `
    <input type="text" ng-model="$ctrl.text" ng-keypress="$ctrl.keypress($event)" />
    <div ng-repeat="obj in $ctrl.data track by $index" ng-class="obj.checked?'checked':''">
       <input type="checkbox" ng-model="obj.checked"/><label>{{obj.text}}</label>
    </div>`,
    controller:TodoForm,
    controllerAs:'$ctrl'
  }
})

angular.bootstrap(document.body, [app.name])