<template>
  <div>
    <!-- 新規作成部分 -->
    <div class="row">
      <div class="col s10 m11">
        <input class="form-control" placeholder="Add your task!!" v-model="newTask">
      </div>
      <div class="col s2 m1">
        <div class="btn-floating waves-effect waves-light red" @click="addTask">
          <i class="material-icons">add</i>
        </div>
      </div>
    </div>
    <!-- リスト表示部分 -->
    <div>
      <ul class="collection">
        <li v-for="task in tasks" v-if="!task.is_done" @click="doTask(task.id)" class="collection-item">
          <input type="checkbox" v-bind:id="'task_' + task.id" />
          <label v-bind:for="'task_' + task.id">{{ task.name }}</label>
        </li>
      </ul>
    </div>
    <!-- 完了済みタスク表示ボタン -->
    <div class="btn" @click="toggleFinishedTasks">Display finished tasks</div>
    <!-- 完了済みタスク一覧 -->
    <div id="finished-tasks" class="display_none" v-if="displayFinishedTasks">
      <ul class="collection">
        <li v-for="task in tasks" v-if="task.is_done" @click="undoTask(task.id)" class="collection-item">
          <input type="checkbox" v-bind:id="'task_' + task.id" />
          <label v-bind:for="'task_' + task.id">{{ task.name }}</label>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
  import axios from 'axios';
  export default {
    data: function () {
      return {
        tasks: [],
        newTask: '',
        displayFinishedTasks: false
      }
    },
    mounted: function () {
      this.fetchTasks();
    },
    methods: {
      fetchTasks: function () {
        axios.get('/api/tasks.json').then((response) => {
          this.tasks = response.data.tasks
        }, (error) => {
          console.log(error);
        });
      },
      toggleFinishedTasks: function () {
        this.displayFinishedTasks = !this.displayFinishedTasks
      },
      addTask: function(){
        axios
          .post('/api/tasks.json', { 'name': this.newTask })
          .then((response) => {
            this.fetchTasks()
            this.newTask = ''
          });
      },
      doTask: function(task_id){
        axios
          .put('/api/tasks/' + task_id + '.json', { is_done: 'true' })
          .then((response) => {
            this.fetchTasks()
          });
      },
      undoTask: function(task_id){
        axios
          .put('/api/tasks/' + task_id + '.json', { is_done: 'false' })
          .then((response) => {
            this.fetchTasks()
          });
      },
    }
  }
</script>
