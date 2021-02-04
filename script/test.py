##from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout
from PyQt5.QtWidgets import *
import os

app = QApplication([])
#app.setStyle('Windows')
app.setStyle('Fusion')
window = QWidget()
layout = QVBoxLayout()

button_top=QPushButton('RTL-VIEW')
button_bottom=QPushButton('RUN_ALL')

def rtl_view_clicked():
    os.system("make verdi")
    ##alert = QMessageBox()
    ##alert.setText('You clicked the button!')
    ##alert.exec_()

def run_all_clicked():
    os.system("./run_all DUMP")


button_top.clicked.connect(rtl_view_clicked)
button_bottom.clicked.connect(run_all_clicked)

layout.addWidget(button_top)
layout.addWidget(button_bottom)
window.setLayout(layout)
window.show()
app.exec_()
