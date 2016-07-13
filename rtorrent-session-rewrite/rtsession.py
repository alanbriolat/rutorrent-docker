#!/usr/bin/env python2
from collections import Counter
import os

from bencode import Bencoder
import click


def get_ancestors(path):
    path = path.split(os.sep)
    for i in xrange(2, len(path)):
        yield os.sep.join(path[0:i])


@click.group()
def cli():
    pass


@cli.command()
@click.argument('path', type=click.Path(exists=True, dir_okay=True, file_okay=False))
def scan(path):
    """Scan rtorrent session files for common paths."""
    counts = Counter()
    for dirpath, dirnames, filenames in os.walk(path):
        for filename in filenames:
            if filename.endswith('.rtorrent'):
                filepath = os.path.join(dirpath, filename)
                with open(filepath, 'rb') as f:
                    data = Bencoder.decode(f.read())
                counts.update(get_ancestors(data.get('directory', '')))
                counts.update(get_ancestors(data.get('loaded_file', '')))

    for p, c in counts.most_common():
        print p, ':', c


@cli.command()
@click.argument('path', type=click.Path(exists=True, dir_okay=True, file_okay=False))
@click.option('-m', '--mapping', multiple=True, help='Path rewrite in the form "from:to"')
def rewrite(path, mapping=None):
    """Rewrite paths in rtorrent session files."""
    mapping = mapping or []
    mapping = [tuple(m.split(':', 1)) for m in mapping]
    for dirpath, dirnames, filenames in os.walk(path):
        for filename in filenames:
            if filename.endswith('.rtorrent'):
                filepath = os.path.join(dirpath, filename)
                with open(filepath, 'rb') as f:
                    data = Bencoder.decode(f.read())
                print data
                for key in ('directory', 'loaded_file'):
                    if key in data:
                        value = data[key].decode('utf-8')
                        for orig, new in mapping:
                            if value.startswith(orig):
                                print 'updating', value
                                data[key] = value.replace(orig, new, 1).encode('utf-8')
                                print 'to', data[key]
                                break
                print data
                with open(filepath, 'wb') as f:
                    f.write(Bencoder.encode(data))


if __name__ == '__main__':
    cli()
