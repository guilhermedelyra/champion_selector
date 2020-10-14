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
champ_name_to_keyword = {}
suggestions_file = {}

def fill_list_of_champs():
    url = base_url+'statistics/'    
    req = requests.get(url, headers=headers)
    html = req.text

    for token in html.split('name":"')[1:]:
        name = token.split('","id"')[0].split('","image":')[0]
        key = html.split(f'"name":"{name}","image":"')[-1].split('.png')[0]

        champ_name_to_keyword[name] = key

    # print(champ_name_to_keyword.keys())
    suggestions_file = { "champions" : [{'keyword': v, 'autocompleteTerm': k} for k,v in champ_name_to_keyword.items()] }

    get_champions_per_role(html)

def get_champions_per_role(html):
    for role in roles:
        split_json = f'"{role}","title":"'
        champions_winrate = [{'name': t.split('","general":{')[0], 'winrate': t.split('","general":{')[-1].split(',')[0].split(':')[-1]} for t in html.split(split_json)[1:]]
        for ch in champions_winrate:
            champions_per_role[role][champ_name_to_keyword[ch['name']]] = {'winrate': float(ch['winrate']), 'matchups':{}, 'adcsupport':{}, 'synergy':{}}

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
        loaded_json = json.loads(json_data)[type_of_pair]
        for obj in loaded_json:
            champions_per_role[role][champ][type_of_pair][obj['key']] = obj['winRate']


def fill_matchups_synergy_adcsupport():
    for role in champions_per_role.keys():
        for champ, winrate in champions_per_role[role].items():
            url = base_url+'champion/'+champ+f'/{role}'
            get_and_set_champ_winrate(url, role, champ)

fill_list_of_champs()
fill_matchups_synergy_adcsupport()

with open('champions.json', 'w') as outfile:
    json.dump(suggestions_file, outfile, indent=4, sort_keys=True)

with open('data.json', 'w') as outfile:
    json.dump(champions_per_role, outfile, indent=4, sort_keys=True)
