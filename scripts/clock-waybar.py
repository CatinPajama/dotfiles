import subprocess

clock_icons = [
"󰀀 ",
"󰀌 ",
"󰀘 ",
"󰀤 ",

"󰀰 ",
"󰀼 ",
"󰁈 ",
"󰁔 ",
"󰁠 ",
"󰁬 ",
"󰁸 ",
"󰂄 ",
"󰁈 ",
]

hour = int(subprocess.check_output(["date", "+\"%I\""]).strip()[1:-1])

#time = subprocess.getoutput((["date +\"%H:%M   %Y, %d %B %A\""]))

print(clock_icons[hour])
