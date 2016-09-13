require 'jobs/version'
require 'jobs/dependency_error'
require 'jobs/circular_dependency_error'

class Jobs

  def initialize(job_struct)
    @sequence = []
    @job_struct = job_struct

    # Make sure we've been provided with the correct parameter type
    raise ArgumentError, '' unless @job_struct.is_a? Hash or String

    return @sequence if @job_struct.is_a? String and @job_struct.empty?

    @job_struct.each do |job,dependent_job|

      # Check the job structure
      raise ArgumentError, 'jobs must be symbols' unless job.is_a? Symbol
      raise ArgumentError, 'dependent job must be a symbol or nil' unless job.is_a? Symbol or job.is_a? NilClass
      raise DependencyError, "Jobs can't depend on themselves" if job == dependent_job

      # Check if this job has already been processed (as a dependency of another job)
      next if @sequence.include? job

      unless dependent_job.nil?
        unless @sequence.include? dependent_job
          # This job has at least one dependency so we need to ensure it's dependent job(s) is/are executed first
          @sequence.concat process_dependency(job, dependent_job)
        end
      end

      # Add the job to the job sequence
      @sequence.push job

    end
  end

  def to_s
    # Return the job sequence as a string
    @sequence.join
  end

  private

  def process_dependency(job, dependency)

    # Stop endless loop if there are circular dependencies and raise a suitable error
    if job == dependency
      raise CircularDependencyError, "Jobs can't have circular dependencies"
    end

    # No dependencies of it's own, so it can be run on it's own
    return [dependency] if @job_struct[dependency].nil?

    # Dependency has dependencies of it's own so we need to process them first
    dependent_job = @job_struct[dependency]

    unless @job_struct[dependent_job].nil?
      # The dependency is dependent on another job
      process_dependency job, @job_struct[dependent_job]
    end

    # The dependency doesn't have any dependencies of it's own
    [dependent_job,dependency]

  end

end
