function run(argv){
  of = Library('OmniFocus')

  //j = JSON.parse(argv[0])
  //deferDate = (j.deferDate? (new Date(j.deferDate)) : nil)
  //dueDate = (j.dueDate? (new Date(j.dueDate)) : nil)
  //of.makeTask(j.text, '@home', deferDate, dueDate, j.project)
  of.parse(argv[0])
}
