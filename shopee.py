from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from datetime import datetime
from bs4 import BeautifulSoup
import time
import pandas as pd 
import sys
sys.stdout.reconfigure(encoding='utf-8')


opsi = webdriver.ChromeOptions()
opsi.add_argument('--headless')
servis = Service('chromedriver.exe')
driver = webdriver.Chrome(service = servis, options = opsi)

shopee_link = "https://shopee.co.id/Komputer-Aksesoris-cat.11044364"
driver.set_window_size(1600, 800)
driver.get(shopee_link)
time.sleep(5)
driver.save_screenshot("home1.png")
content = driver.page_source
driver.quit()


data = BeautifulSoup(content,'html.parser')
## print(data.encode("utf-8"))

i = 1
for area in data.find_all('div', class_="col-xs-2-4 shopee-search-item-result__item") :
    print(i)
    nama_produk = area.find('div', class_ = "_1yN94N WoKSjC _2KkMCe")
    if nama_produk != None:
        nama_produk = nama_produk.get_text()
    harga = area.find('span', class_="du3pq0")
    if harga != None:
        harga = harga.get_text()
    link = area.find('a')['href']
    terjual = area.find('div', class_="x+3B8m wOebCz")
    if terjual != None:
        terjual = terjual.get_text()
    lokasi = area.find('div', class_="mrz-bA")
    if lokasi != None:
        lokasi = lokasi.get_text()
    print(harga)
    print(link)
    print(terjual)
    print(lokasi)
    i +=1
    print("----")