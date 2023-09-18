import os
from RLTest import Env


def symlink_rdb(rdb_filename, env):
    dbDir = env.cmd('config', 'get', 'dir')[1].decode('utf-8')
    rdbFilePath = os.path.join(dbDir, rdb_filename)
    filePath = os.path.join("./rdb", rdb_filename)
    try:
        os.unlink(rdbFilePath)
    except OSError:
        pass
    os.symlink(filePath, rdbFilePath)

def test_nograph(env):
    symlink_rdb("no_graph_x1.rdb", env)
    env.stop()
    env.start()
    env.assertEquals("RedisCompat", env.cmd("module", "list")[0][1].decode('utf-8'))

def test_del_graph(env):
    symlink_rdb("del_graph_x2.rdb", env)
    env.stop()
    env.start()
    env.assertEquals("RedisCompat", env.cmd("module", "list")[0][1].decode('utf-8'))
