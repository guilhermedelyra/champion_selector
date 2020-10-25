import sys
import urllib3
import requests
import json
from collections import defaultdict, OrderedDict
import re

def main():
    base_url = 'https://champion.gg/'
    headers = {'User-Agent': 'Mozilla/5.0'}

    roles = ['Support', 'ADC', 'Top', 'Middle', 'Jungle']

    def fill_list_of_champs():
        champ_name_to_keyword = {}
        suggestions_file = {}
        url = base_url+'statistics/'    
        req = requests.get(url, headers=headers)
        html = req.text

        for token in html.split('name":"')[1:]:
            name = token.split('","id"')[0].split('","image":')[0]
            key = html.split(f'"name":"{name}","image":"')[-1].split('.png')[0]

            champ_name_to_keyword[name] = key

        suggestions_file = { "champions" : [{'keyword': v, 'autocompleteTerm': k} for k,v in champ_name_to_keyword.items()] }

        return suggestions_file

    return fill_list_of_champs()
if __name__ == "__main__":
    suggestions_file = main()
    print(json.dumps(suggestions_file, indent=4, sort_keys=True))
# print(json.dumps({'oi':3}, indent=4, sort_keys=True))



