# gocd

[![Gem Version](https://badge.fury.io/rb/gocd.svg)](https://badge.fury.io/rb/gocd)

### Installation
```ruby
gem 'gocd'
```

or

```bash
gem install gocd
```

### Code Documentation
http://www.rubydoc.info/gems/gocd/1.2.1

### Usage

```ruby
GOCD.server = GOCD::Server.new 'http://goserverurl.com'
GOCD.credentials = GOCD::Credentials.new 'username', 'password'
```

###### To check all pipelines:
```ruby
GOCD::AllPipelines.red_pipelines
```

###### To check a group of pipelines:

```ruby
pipelines = GOCD::PipelineGroup.new ['Pipeline1 :: stage1', 'Pipeline1 :: stage2', 'Pipeline2 :: stage1']
pipelines.red_pipelines
pipelines.status
pipelines.any_red?
```

###### To get all the idle agents:
```ruby
idle_agents = GOCD::Agents.idle
idle_agents.each { |agent| agent.name }
```

###### To get all the missing agents:
```ruby
GOCD::Agents.missing
```

###### To get all the disabled agents:
```ruby
GOCD::Agents.disabled
```

#### Pipeline Configuration

###### To get all the environments
```ruby
include GOCD::PIPELINE_CONFIG

environments #return all the environments and the whole hierarchy of it
jobs = environments.map(&:pipelines).flatten.map(&:stages).flatten.map(&:jobs).flatten
```

##### APIs provided by GOCD::PIPELINE_CONFIG
```ruby
module GOCD
  module PIPELINE_CONFIG
    def environments
    end

    def pipelines
    end

    def templates
    end

    def groups
    end

    def pipeline_config_response
    end
  end
end

module GOCD
  module PIPELINE_CONFIG
    class Environment
      attr_reader :name, :pipelines, :pipeline_names
    end
  end
end

module GOCD
  module PIPELINE_CONFIG
    class Pipeline
      attr_reader :name, :stages, :template, :environment
    end
  end
end

module GOCD
  module PIPELINE_CONFIG
    class Stage
      attr_reader :pipeline, :name, :jobs, :environment
    end
  end
end

module GOCD
  module PIPELINE_CONFIG
    class Job
      attr_reader :pipeline, :stage, :name, :resources, :environment
    end
  end
end
```

#### History Fetcher
You can fetch history of a job using the HistoryFetcher APIs
```ruby
require 'gocd'

GOCD.server = GOCD::Server.new 'http://goserverurl.com'
GOCD.credentials = GOCD::Credentials.new 'username', 'password'

include GOCD::PIPELINE_CONFIG

histories = []
runs = 1000
jobs = environments.map(&:pipelines).flatten.map(&:stages).flatten.map(&:jobs).flatten
jobs.each do |job|
  histories << GOCD::HistoryFetcher.fetch_job_history(job, runs)
end
```

LICENSE
-------

```LICENSE
Copyright (C) 2016 Ajit Singh

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
