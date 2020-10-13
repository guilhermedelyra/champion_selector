import sys
import urllib3
import requests
import json
from collections import defaultdict, OrderedDict
import re

base_url = 'https://champion.gg/'
headers = {'User-Agent': 'Mozilla/5.0'}

roles = ['Support', 'ADC', 'Top', 'Middle', 'Jungle']
champions_per_role = dict((role, dict({})) for role in roles)
list_of_all_champions = []

def fill_list_of_champs():
    global list_of_all_champions
    global champions_per_role
    for role in champions_per_role.keys():
        list_of_all_champions += champions_per_role[role].keys()
    
    list_of_all_champions = sorted(set(list_of_all_champions))


def get_champions_per_role():
    url = base_url+'statistics/'
    req = requests.get(url, headers=headers)
    html = req.text

    for role in roles:
        split_json = f'"{role}","title":"'
        champions_winrate = [{'name': t.split('","general":{')[0], 'winrate': t.split('","general":{')[-1].split(',')[0].split(':')[-1]} for t in html.split(split_json)[1:]]
        for ch in champions_winrate:
            champions_per_role[role][ch['name']] = {'winrate': ch['winrate']}

def get_and_set_champ_winrate(url, role, champ, ext='?league='):
    pairs = [
        'matchups',
        'adcsupport',
        'synergy'
    ]
    http = urllib3.PoolManager(
        retries=urllib3.Retry(5, redirect=2)
    )
    response = http.request('GET', url+ext, headers=headers)
    if int(response.status) == 503:
        if ext == '':
            get_and_set_champ_winrate(url, role, champ, ext='?')            
        if ext == '?league=':
            get_and_set_champ_winrate(url, role, champ, ext='')
        return
    html = response.data.decode('utf-8')
    json_data = html.split('matchupData.championData = ')[-1].split('\n')[0]
    global champions_per_role
    for type_of_pair in pairs:
        champions_per_role[role][champ][type_of_pair] = json.loads(json_data)[type_of_pair]


def fill_matchups_synergy_adcsupport():
    for role in champions_per_role.keys():
        for champ, winrate in champions_per_role[role].items():
            champ_name_for_url = re.sub(r'[^a-zA-Z]', '', champ).title()
            url = base_url+'champion/'+champ_name_for_url+f'/{role}'
            get_and_set_champ_winrate(url, role, champ)            

get_champions_per_role()
fill_list_of_champs()
fill_matchups_synergy_adcsupport()

# with open('champions.json', 'w') as outfile:
#     json.dump(list_of_all_champions, outfile, indent=4, sort_keys=True)

with open('assets/data.json', 'w') as outfile:
    json.dump(champions_per_role, outfile, indent=4, sort_keys=True)
