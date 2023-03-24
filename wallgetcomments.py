import sqlite3
import vk

session = vk.Session(access_token='token')  # токен доступа VK API
api = vk.API(session)

post_id = '123456'  # id поста, комментарии к которому нужно получить

start_time = '2022-01-01 00:00:00'  # начальная дата публикации
end_time = '2022-01-31 23:59:59'  # конечная дата публикации

# перевод даты в Unix timestamp
start_time_unix = int(datetime.datetime.strptime(start_time, '%Y-%m-%d %H:%M:%S').timestamp())
end_time_unix = int(datetime.datetime.strptime(end_time, '%Y-%m-%d %H:%M:%S').timestamp())

# запрос к методу execute
code = """
var count = Args.count;
var items = [];
var i = 0;
while (i < count) {
    var offset = i * 100;
    var comments = API.wall.getComments({
        "owner_id": Args.group_id,
        "post_id": Args.post_id,
        "count": 100,
        "offset": offset,
        "start_time": Args.start_time,
        "end_time": Args.end_time
    });
    items = items + comments.items;
    i = i + 1;
}
return items;
"""

# выполнение запроса
comments = api.execute(code=code, post_id=post_id, count=count, start_time=start_time_unix, end_time=end_time_unix)

# создание подключения к базе данных SQLite
conn = sqlite3.connect('vk_comments.db')

# создание таблицы в базе данных
conn.execute('CREATE TABLE IF NOT EXISTS comments (id INTEGER PRIMARY KEY, text TEXT, likes INTEGER, reply_to INTEGER)')

# вставка данных в таблицу
for comment in comments:
    conn.execute('INSERT INTO comments (id, text, likes, reply_to) VALUES (?, ?, ?, ?)',
                 (comment['id'], comment['text'], comment['likes']['count'], comment['reply_to_comment']))

# сохранение изменений в базе данных
conn.commit()

# закрытие подключения к базе данных
conn.close()
