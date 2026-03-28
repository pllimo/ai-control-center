#!/usr/bin/env python3
"""
build-viz.py — 从 Markdown 文件生成可视化数据
读取 profile/ 和 memory/，输出 viz-data.json 供 visualization.html 使用
"""

import json
import os
import re
from datetime import datetime
from pathlib import Path

def get_cc_home():
    env = os.environ.get("CONTROL_CENTER_HOME")
    if env:
        return Path(env)
    # 默认：脚本目录的上一级
    return Path(__file__).parent.parent

def parse_date(text):
    """从文本中提取日期"""
    patterns = [
        r'(\d{4}-\d{2}-\d{2})',
        r'最后更新[：:]\s*(\d{4}-\d{2}-\d{2})',
    ]
    for p in patterns:
        m = re.search(p, text)
        if m:
            return m.group(1)
    return None

def read_file_safe(path):
    try:
        return path.read_text(encoding='utf-8')
    except Exception:
        return ""

def parse_user_profile(cc_home):
    """解析用户画像"""
    profile = {
        "identity": "",
        "thinking": "",
        "collaboration": "",
        "last_updated": None
    }
    text = read_file_safe(cc_home / "profile" / "user.md")
    if not text:
        return profile

    # 提取各个部分的第一段内容
    sections = re.split(r'^##\s+', text, flags=re.MULTILINE)
    for section in sections:
        lines = section.strip().split('\n')
        if not lines:
            continue
        title = lines[0].strip()
        content = '\n'.join(l for l in lines[1:] if l.strip() and not l.startswith('<!--')).strip()
        if '我是谁' in title:
            profile["identity"] = content[:120] if content else ""
        elif '思维' in title:
            profile["thinking"] = content[:120] if content else ""
        elif '协作' in title or 'AI' in title:
            profile["collaboration"] = content[:120] if content else ""

    profile["last_updated"] = parse_date(text)
    return profile

def parse_rules(cc_home):
    """解析协作规则"""
    rules = {"do": [], "dont": []}
    text = read_file_safe(cc_home / "profile" / "rules.md")
    if not text:
        return rules

    current = None
    for line in text.split('\n'):
        if '永远要做' in line:
            current = 'do'
        elif '永远不要' in line:
            current = 'dont'
        elif line.startswith('- ') and current:
            item = line[2:].strip()
            if item and not item.startswith('示例'):
                rules[current].append(item)

    return rules

def parse_goals(cc_home):
    """解析目标"""
    goals = []
    text = read_file_safe(cc_home / "profile" / "goals.md")
    if not text:
        return goals

    for line in text.split('\n'):
        m = re.match(r'^\d+\.\s+(.+)', line.strip())
        if m:
            goals.append(m.group(1).strip())

    return goals[:3]

def parse_global_memory(cc_home):
    """解析全局记忆，提取各条经验"""
    entries = []
    text = read_file_safe(cc_home / "memory" / "global.md")
    if not text:
        return entries

    # 按 ### 分割
    blocks = re.split(r'^###\s+', text, flags=re.MULTILINE)
    for block in blocks[1:]:  # 跳过第一块（文件说明）
        lines = block.strip().split('\n')
        if not lines:
            continue
        header = lines[0].strip()

        # 提取日期和标题
        date_match = re.match(r'(\d{4}-\d{2}-\d{2})\s*[-–]\s*(.+)', header)
        if date_match:
            date = date_match.group(1)
            title = date_match.group(2).strip()
        else:
            date = None
            title = header

        # 提取场景和要点
        content = '\n'.join(lines[1:])
        scene_match = re.search(r'\*\*场景\*\*[：:]\s*(.+?)(?=\n\*\*|\Z)', content, re.DOTALL)
        scene = scene_match.group(1).strip()[:80] if scene_match else ""

        # 提取学到的要点（最多2条）
        learned = re.findall(r'^- (.+)', content, re.MULTILINE)[:2]

        if title and title != header.strip() or date:
            entries.append({
                "date": date,
                "title": title[:50],
                "scene": scene,
                "learned": learned
            })

    # 按日期排序
    entries.sort(key=lambda x: x.get('date') or '0000-00-00')
    return entries

def parse_projects(cc_home):
    """解析项目卡片"""
    projects = []
    projects_dir = cc_home / "memory" / "projects"
    if not projects_dir.exists():
        return projects

    for f in sorted(projects_dir.glob("*.md")):
        if f.name == '.gitkeep':
            continue
        text = read_file_safe(f)
        if not text:
            continue

        # 提取项目名（第一个 # 标题）
        name_match = re.search(r'^#\s+(.+)', text, re.MULTILINE)
        name = name_match.group(1).strip() if name_match else f.stem

        # 提取目标
        goal_match = re.search(r'##\s+目标\n+(.+?)(?=\n##|\Z)', text, re.DOTALL)
        goal = goal_match.group(1).strip()[:100] if goal_match else ""

        # 提取阶段
        stage_match = re.search(r'##\s+当前阶段\n+(.+?)(?=\n##|\Z)', text, re.DOTALL)
        stage = stage_match.group(1).strip()[:60] if stage_match else ""

        # 提取下一步（最多2条）
        next_steps = re.findall(r'- \[ \] (.+)', text)[:2]

        # 提取最后更新
        last_updated = parse_date(text)

        projects.append({
            "name": name,
            "goal": goal,
            "stage": stage,
            "next_steps": next_steps,
            "last_updated": last_updated,
            "file": f.name
        })

    return projects

def count_memory_by_month(entries):
    """统计每月记忆条数（用于时间线图表）"""
    counts = {}
    for e in entries:
        if e.get('date'):
            month = e['date'][:7]  # YYYY-MM
            counts[month] = counts.get(month, 0) + 1
    return [{"month": k, "count": v} for k, v in sorted(counts.items())]

def main():
    cc_home = get_cc_home()
    output_file = cc_home / "viz-data.json"

    print(f"读取路径：{cc_home}")

    profile = parse_user_profile(cc_home)
    rules = parse_rules(cc_home)
    goals = parse_goals(cc_home)
    memory_entries = parse_global_memory(cc_home)
    projects = parse_projects(cc_home)
    memory_by_month = count_memory_by_month(memory_entries)

    data = {
        "generated_at": datetime.now().strftime('%Y-%m-%d %H:%M'),
        "profile": profile,
        "rules": rules,
        "goals": goals,
        "memory_entries": memory_entries,
        "memory_by_month": memory_by_month,
        "projects": projects,
        "stats": {
            "total_memories": len(memory_entries),
            "total_projects": len(projects),
            "profile_updated": profile.get("last_updated"),
        }
    }

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print(f"✓ 已生成：{output_file}")
    print(f"  记忆条数：{len(memory_entries)}")
    print(f"  项目数：{len(projects)}")

if __name__ == '__main__':
    main()
