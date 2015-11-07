class ProjectManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def projects(page: 1)
    client.repos(nil, per_page: 100, page: page).map { |repo| Project.new(repo) }
  end

  def find_project(id)
    client.repo(id)
  end

  def deadlines_for(id)
    client.list_milestones(id)
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: user.github_token)
  end

  class Project
    include Charlatan.new(:original)

    def id
      original.full_name
    end

    def task_count
      original.open_issues_count
    end
  end

  class Deadline
    include Charlatan.new(:original)
  end
end