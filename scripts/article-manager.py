#!/usr/bin/env python3
import os
import re
from datetime import datetime, timedelta

class ArticleManager:
    def __init__(self, content_dir="content/articles", drafts_dir="content/drafts/ready"):
        self.content_dir = content_dir
        self.drafts_dir = drafts_dir
        
    def schedule_articles(self, start_date, days=7):
        """為準備好的文章安排發布時間"""
        ready_files = os.listdir(self.drafts_dir)
        ready_files = [f for f in ready_files if f.endswith('.md')]
        
        for i, filename in enumerate(ready_files[:days]):
            publish_date = start_date + timedelta(days=i)
            self.set_publish_date(
                os.path.join(self.drafts_dir, filename),
                publish_date
            )
            print(f"已安排 {filename} 於 {publish_date.strftime('%Y-%m-%d')} 發布")
    
    def set_publish_date(self, filepath, publish_date):
        """設定文章的發布日期"""
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 更新 publishDate
        publish_str = publish_date.strftime('%Y-%m-%dT08:00:00+08:00')
        content = re.sub(
            r'publishDate:.*',
            f'publishDate: {publish_str}',
            content
        )
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

if __name__ == "__main__":
    manager = ArticleManager()
    
    # 從明天開始安排一週的文章
    tomorrow = datetime.now() + timedelta(days=1)
    manager.schedule_articles(tomorrow, days=7)
