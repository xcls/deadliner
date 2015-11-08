class ProjectManager
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def github_user
    @github_user ||= client.user
  end

  def projects(page: 1)
    wrap_with Project, client.repos(nil, {
      page: page,
      sort: :pushed,
      direction: :desc
    })
  end

  def find_project(id)
    Project.new client.repo(id)
  end

  def deadlines_for(id)
    wrap_with Deadline, client.list_milestones(id, state: :open)
  end

  def find_deadline(project_id, id)
    Deadline.new(client.milestone(project_id, id))
  end

  def tasks_for(project_id, deadline_id)
    issues_list = client.list_issues(project_id, milestone: deadline_id, state: :open)
    wrap_with Task, issues_list
  end

  private

  def client
    @client ||= Octokit::Client.new(access_token: user.github_token)
  end

  def wrap_with(klass, xs)
    xs.map! { |m| klass.new(m) }
    pagination = GithubPagination.new(client.last_response)
    PaginatedArray.new(xs, pagination)
  end

  class Project
    include Charlatan.new(:original)

    def id
      original.full_name
    end

    def task_count
      original.open_issues_count
    end

    def to_path
      "/projects/github/#{full_name}"
    end

    def owner
      Login.new original.owner
    end
  end

  class Login
    include Charlatan.new(:original)

    def name
      original.login
    end
  end

  class Deadline
    include Charlatan.new(:original)

    def name
      original.title
    end

    def completion_percentage
      ((closed_issues / (open_issues + closed_issues).to_d) * 100.0).round(2)
    end

    def completed?
      completion_percentage.ceil == 100
    end

    def no_due_date?
      due_on.blank?
    end

    def overdue?
      !no_due_date? && (Time.now > due_on.to_time)
    end

    def due_in_seconds
      return 0 if no_due_date?
      due_on.to_i
    end
  end

  class Task
    include Charlatan.new(:original)

    def name
      original.title
    end

    # TODO: We probably don't want to show the description?
    def description_html
      @description_html ||= RDiscount.new(original.body).to_html
    end
  end

  # Designed to work with Kaminari's `paginate`
  class PaginatedArray
    include Charlatan.new(:array)
    attr_reader :pagination

    def initialize(array, pagination)
      super(array)
      @pagination = pagination
    end

    delegate(
      :current_page,
      :limit_value,
      :total_pages,
      to: :pagination
    )
  end

  # Designed to work with Kaminari's `paginate`
  #
  # @see PaginatedArray
  # @see https://developer.github.com/guides/traversing-with-pagination/
  class GithubPagination
    include Charlatan.new(:response)

    def next_page
      @next_page ||= extract_page_for(:next)
    end

    def prev_page
      @prev_page ||= extract_page_for(:prev)
    end

    def current_page
      @current_page ||=
        if next_page
          next_page.to_i - 1
        else
          prev_page.to_i + 1
        end
    end

    def limit_value
      href_for(:next).match(/\bper_page=(\d+)/).try(:[], 1) || 30
    end
    alias_method :per_page, :limit_value

    def total_pages
      (extract_page_for(:last) || current_page).to_i
    end

    private

    def extract_page_for(attr)
      extract_page(href_for(attr))
    end

    def href_for(attr)
      response.rels[attr] ? response.rels[attr].href : ""
    end

    def extract_page(href)
      href.match(/\bpage=(\d+)/).try(:[], 1)
    end
  end
end
