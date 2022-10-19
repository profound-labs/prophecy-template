Prophecy LaTeX Book Template
==============

*Prophecy Subtitle*

By The Author

Paperback status: **N/A**  
Ebook status: **N/A**

First edition

ISBN for paperback: `000-000-0000-00-0`

ISBN for ebooks: `000-0-00000-000-0`

Based on [prophecy-template].

Github: <https://github.com/profound-labs/prophecy-template>

Produced with [LaTeX], [Pandoc] and [Asciidoctor].

[prophecy-template]: https://github.com/profound-labs/prophecy-template

[LaTeX]: http://latex-project.org/

[Pandoc]: http://pandoc.org/

[Asciidoctor]: http://asciidoctor.org/

**NOTE:**

The Ruby libs need the old Ruby v2.6.6.

``` shell
rvm pkg install openssl
rvm install ruby-2.6.6 --with-openssl-dir=$HOME/.rvm/usr
rvm use ruby-2.6.6 --default
gem install bundler:1.13.7
bundle install
bundle exec make epub
```
