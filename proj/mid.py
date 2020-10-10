import sys
from urllib.request import Request, urlopen
import json
from collections import defaultdict, OrderedDict
base_url = 'https://champion.gg/champion/'


def return_champs(champ, key_look, role, champs, div=1, enemy=0):
    url = base_url+champ+role
    req = Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    html = urlopen(req).read().decode('utf-8')
    json_data = json.loads(([l for l in html.split('\n') if "matchupData.championData = " in l])[0].strip('  matchupData.championData ='))[key_look]

    all_champs = dict.fromkeys(champs.keys(), 0)

    for c in json_data:
        champs[c["key"]] += abs(enemy-c["winRate"]) * 100 / div
        all_champs[c["key"]] = 1
    
    for k, v in all_champs.items():
        if (v == 0):
            champs[k] += 0.5 * 100 / div

    return champs

def retrieve_mid_result(args=sys.argv[1:]):   
    div = len([i for i in args if len(i) > 6])
    champs = defaultdict(lambda:0)

    for arg in args:
        champ = arg.split(':')[-1]
        if len(champ) >= 3:
            if "emid" in arg:
                champs = return_champs(champ, "matchups", '/Middle?', champs, div, enemy=1)

    result = {k: format(v, '.2f') for k, v in sorted(champs.items(), key=lambda item: item[1])}
    # print(json.dumps(result, indent=4, sort_keys=False))
    return json.dumps(result, indent=4, sort_keys=False)