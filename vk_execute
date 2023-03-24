import sqlite3
import vk

session = vk.Session(access_token='token')  # токен доступа VK API
api = vk.API(session)

group_id = '123456'  # id группы, данные со стены которой нужно получить
count = 100  # количество записей на стене

# запрос к методу execute
code = """
var count = Args.count;
var items = [];
var i = 0;
while (i < count) {
    var offset = i * 100;
    var posts = API.wall.get({
        "owner_id": Args.group_id,
        "count": 100,
        "offset": offset
    });
    items = items + posts.items;
    i = i + 1;
}
return items;
"""

# выполнение запроса
wall = api.execute(code=code, group_id=group_id, count=count)

# создание подключения к базе данных SQLite
conn = sqlite3.connect('vk_wall.db')

# создание таблицы в базе данных
conn.execute('CREATE TABLE IF NOT EXISTS wall (id INTEGER PRIMARY KEY, text TEXT, likes INTEGER, reposts INTEGER)')

# вставка данных в таблицу
for post in wall:
    conn.execute('INSERT INTO wall (id, text, likes, reposts) VALUES (?, ?, ?, ?)',
                 (post['id'], post['text'], post['likes']['count'], post['reposts']['count']))

# сохранение изменений в базе данных
conn.commit()

# закрытие подключения к базе данных
conn.close()
