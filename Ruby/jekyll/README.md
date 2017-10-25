##jekyll

### 1.安装

```bash
gem install jekyll
```

### 2. 初始化项目

```bash
jekyll new my-project
```

### 3. 启动项目

```bash
cd my-project
# 启动
jekyll serve
```

- 报错

```shell
/usr/local/ruby/lib/ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require': cannot load such file -- bundler (LoadError)
	from /usr/local/ruby/lib/ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/jekyll-3.6.2/lib/jekyll/plugin_manager.rb:48:in `require_from_bundler'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/jekyll-3.6.2/exe/jekyll:11:in `<top (required)>'
	from /usr/local/ruby/bin/jekyll:23:in `load'
	from /usr/local/ruby/bin/jekyll:23:in `<main>'

```
- 解决

```bash

gem install bundler

gem update --system
```

- 报错

```shell
/usr/local/ruby/lib/ruby/gems/2.4.0/gems/bundler-1.15.4/lib/bundler/resolver.rb:396:in `block in verify_gemfile_dependencies_are_found!': Could not find gem 'minima (~> 2.0)' in any of the gem sources listed in your Gemfile. (Bundler::GemNotFound)
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/bundler-1.15.4/lib/bundler/resolver.rb:366:in `each'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/bundler-1.15.4/lib/bundler/resolver.rb:366:in `verify_gemfile_dependencies_are_found!'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/bundler-1.15.4/lib/bundler/resolver.rb:212:in `start'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/bundler-1.15.4/lib/bundler/resolver.rb:191:in `resolve'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/bundler-1.15.4/lib/bundler/definition.rb:235:in `resolve'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/bundler-1.15.4/lib/bundler/definition.rb:159:in `specs'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/bundler-1.15.4/lib/bundler/definition.rb:218:in `specs_for'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/bundler-1.15.4/lib/bundler/definition.rb:207:in `requested_specs'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/bundler-1.15.4/lib/bundler/runtime.rb:109:in `block in definition_method'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/bundler-1.15.4/lib/bundler/runtime.rb:21:in `setup'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/bundler-1.15.4/lib/bundler.rb:101:in `setup'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/jekyll-3.6.2/lib/jekyll/plugin_manager.rb:50:in `require_from_bundler'
	from /usr/local/ruby/lib/ruby/gems/2.4.0/gems/jekyll-3.6.2/exe/jekyll:11:in `<top (required)>'
	from /usr/local/ruby/bin/jekyll:23:in `load'
	from /usr/local/ruby/bin/jekyll:23:in `<main>'


```

- 解决

```shell
 bundle install  
```

- 启动

```bash
# 指定ip
jekyll serve --host=0.0.0.0
```
