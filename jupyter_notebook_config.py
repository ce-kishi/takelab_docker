# Configuration file for jupyter-notebook.

c = get_config()
c.IPKernelApp.pylab = 'inline'
c.NotebookApp.ip = '0.0.0.0'  # (過去バージョンでは'*'指定だったけど今はだめみたい。)
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
# (#先ほど保存したハッシュ値を記載)
c.NotebookApp.token = ''
