import datetime
from os import system as sh
from time import sleep

class os:
    @staticmethod
    def system(cmd):
        print('[' + str(now) + '] '+cmd)
        sh(cmd)

# dedine local and remote path and temp path
# 此处目录结尾不要带/
local_path = '/root/MC-Server/BackUp/slot2'
remote_path = '/backup'
temp_path = '/root/aliyunpan/temp'
# aliyun app path
# 此为可执行文件路径，请提前完成登陆，此脚本会自动刷新token
# 阿里云盘程序参考 https://github.com/tickstep/aliyunpan 安装，登陆
aliyunpan_app_path = '/root/aliyunpan/aliyunpan'

# define smtp email
# 尚未实现
server = 'smtp.163.com'
user = ''
password = ''
port = 25

# run at 2:00 am every day
hour = 2
while True:
    # get current hour
    now = datetime.datetime.now()
    # get format time
    date = now.strftime('%Y%m%d')
    print('------[' + str(now) + ']------Start------')
    if now.hour == hour:
        # archieve local file to temp file
        os.system('tar -zcvf ' + temp_path + '/' +
                  date + '.tar.gz ' + local_path)
        # upload temp file to remote
        os.system( aliyunpan_app_path + ' upload ' +
                  temp_path + '/' +
                  date + '.tar.gz' + ' ' + remote_path)
        # delete temp file
        os.system('rm ' + temp_path + '/' +
                  date + '.tar.gz')

    # update refresh token
    os.system(aliyunpan_app_path + " token update")
    print('------[' + str(now) + ']------Done------')
    # 每隔一小时检查一次是否需要备份，并更新token
    sleep(3600)
