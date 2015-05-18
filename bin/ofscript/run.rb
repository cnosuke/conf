require 'json'
require 'pry'
# require ''

MAX_PLACEHOLDER = Time.now + (60*60*24*7)

str =<<JS
of = Library('OmniFocus')
tasks = of.allTasks()
names = []
tasks.forEach(function(e){
  var ctx = (e.context() ? e.context.name() : null)
  var obj = {
    id: e.id(),
    name: e.name(),
	context: ctx,
	deferDate: e.deferDate(),
	dueDate: e.dueDate(),
	note: e.note(),
  }
  names.push(obj)
})
JSON.stringify(names)
JS

j = ''
IO.popen("osascript -l JavaScript -e \"#{str}\" "){|io| j = io.read }
j = JSON.parse(j).map{|e|
  e.merge!({
    'dueDate' => (e['dueDate'] ? Time.parse(e['dueDate']) : nil),
    'deferDate' => (e['deferDate'] ? Time.parse(e['deferDate']) : nil)
  })
}

j = j.sort_by{|e| (e['dueDate'] ? e['dueDate'] : MAX_PLACEHOLDER ) }

binding.pry
