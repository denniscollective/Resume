require "date"
require "json"

class Job
  ATTRIBUTES = [:website, :start_date, :end_date, :title, :skills, :description]
  attr_accessor *ATTRIBUTES

  def initialize(company)
    @company = company
  end

  def description
    "\n      " + @description.strip
  end

  def start_date
    @start_date.to_s
  end

  def end_date
    @end_date && @end_date.to_s #apprently try is active support?
  end

  def to_hash
    {
      @company => ATTRIBUTES.inject({}) do |job, attribute|
        value = self.send(attribute)
        job.merge!(attribute => value) if value
        job
      end
    }
  end
end

class History
  def rails_dev
    [:ruby, :pair_programming, :test_driven_development, :rails, :javascript, :jquery]
  end

  def javascript_superstar
    [:backbone, :coffeescript, :node]
  end

  def internaut
    Job.new("Internaut Design").tap do |job|
      job.website = "http://internautdesign.com"
      job.start_date = Date.parse("2009-6-1")
      job.end_date = Date.parse("2010-1-15")
      job.title = "Intern-Superstar"
      job.skills = rails_dev
      job.description = <<-DESCRIPTION
      Learned Rails Development/Industry Best Practices by pairing with team members on the consultancy's
      scrum project management tool "ScrumNinja", as well as client projects.
      DESCRIPTION
    end
  end

  def circle_voting
    Job.new("Circle Voting").tap do |job|
      job.start_date = Date.parse("2010-1-15")
      job.end_date = Date.parse("2010-10-1")
      job.title = "Software Developer"
      job.skills = rails_dev
      job.description = <<-DESCRIPTION
      Developed a social network around voting and civic activism for the 2010 mid-term elections.
      DESCRIPTION
    end
  end

  def pivotal
    Job.new("Pivotal Labs").tap do |job|
      job.website = "http://pivotallabs.com"
      job.start_date = Date.parse("2011-1-1")
      job.end_date = Date.parse("2011-12-31")
      job.title = "Agile Software Engineer"
      job.skills = [:pair_programming, :test_driven_development, :team_building, :rails, :javascript, :consulting, :agile]
      job.description = <<-DESCRIPTION
      Worked with Pivotal Labs to Develop applications for clients. The clients presented many different
      needs such as having a team trained up, working with existing teams to refine practices and add
      horsepower, help prioritize a sensible course of development for the business trajectory, and glitter.
      DESCRIPTION
    end
  end


  def diaspora
    Job.new("Diaspora").tap do |job|
      job.website = "https://joindiaspora.com"
      job.start_date = Date.parse("2012-1-1")
      job.end_date = Date.parse("2012-1-7")
      job.title = "Chief Magical Officer"
      job.skills = [:tech_lead, :scaling_rails, :lean_startuping, :javascript_superstardom, :fire_fighting]
      job.description = <<-DESCRIPTION
      Diaspora is a distributed open source social network. On joining the core team was burdened with
      a heavy operations cost, which was holding back development from being able to scale the platform
      effectively. Through a separation of client and server side applications, server throughput was
      increased by an order of magnitude. Development of the client as a Javascript Application
      (Backbone) allowed us to rapidly iterate on experimental experiences. We delivered a completely
      different product called Makr.io (https://makr.io/) that utilized the existing server
      architecture.

      Through a simplification of Infrastructure (removing unnecessary services and dependencies) we
      were able to run Diaspora on the Heroku platform, allowing the developers/business owners to
      work on the areas we could innovate, and outsource the non business critical sectors.
      DESCRIPTION
    end
  end

  def blazing_cloud
    Job.new("Blazing Cloud").tap do |job|
      job.start_date = Date.parse("2012-11-15")
      job.title = "Software Artisan"
      job.skills = [:team_lead, :tech_lead, :agile_slash_lean, :team_building, :javascript_and_rails_wizardry]
      job.description = <<-DESCRIPITON
      Work with stake holders to help define products that fill a need.
      Work with developers to build teams that make great software that fills actual business needs.
      DESCRIPITON
    end
  end
end


class Resume
  def history
    @history ||= History.new #wouldn't it be nice to have a new history, just like that?
  end

  def to_hash
    [history.blazing_cloud, history.diaspora, history.pivotal, history.circle_voting, history.internaut].inject({}) { |resume, job| resume.merge(job.to_hash) }
  end

  def for_human #invlaid json, way moar legible for people
    JSON.pretty_generate(to_hash).gsub(/\\n/, "\n")
  end

  def snark
<<SNARK
To regenerate this file run:
    $ ruby resume.rb

You might want to see what else you can learn by reading the source
https://github.com/denniscollective/resume/blob/master/resume.rb

SNARK
  end

  def abstract
<<ABSTRACT
# In Brief:

I enjoy the challenge of working with human beings to create software that fills a real need. I've been making websites
since shortly after I was born; to that end, I am as interested in human aspects as I am the technical side of things.
I try to work sensibly and sustainably with teams who take pride in their work.

## I am not afraid of the words:


* Team
* Ruby
* Javascript
* Backbone
* Service Oriented Architecture (when it is appropriate)
* Object Oriented
* agile (so long as it's a lower case a)
* Lean
* TDD/BDD
* MVP
* Rails (well maybe sometimes a little afraid, but I've got 4 years experience with it)
* Business
* BOOM!

ABSTRACT
  end

  def dump
    File.open("README.md", 'w') do |file|
      file.write(snark)
      file.write(abstract)
      file.write("## Work Herstory\n")
      file.write("```json\n")
      file.write(for_human)
      file.write("\n```")
    end
  end
end

#apparently I feel more comfortable writing code than english, so I had to hide the english in as much code as possible.
#don't worry though, I quite enjoy speaking english, with people even!

resume = Resume.new
resume.dump
