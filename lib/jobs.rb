require 'jobs/version'
require 'jobs/dependency_error'
require 'jobs/circular_dependency_error'

module Jobs

  def self.order(job_struct)

    @sequence = []

    # Make sure we've been provided with the correct parameter type
    raise ArgumentError, '' unless job_struct.is_a? Hash or String

    # If we've not been provided with jobs to run, then return an empty sequence
    return '' if job_struct.is_a? String and job_struct.empty?

    @job_struct = job_struct

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
          dependencies = process_dependency(dependent_job)
          @sequence.concat dependencies
        end
      end

      # Add the job to the job sequence
      @sequence.push job

    end

    # Return the job sequence as a string
    @sequence.join

  end

  private

  def self.process_dependency(dependent_job)
    begin
    if @job_struct[dependent_job].nil?
      # No dependencies of it's own, so it can be run on it's own
      [dependent_job]
    else
      # Dependent job has dependencies of it's own so we need to process them first
      unless @job_struct[@job_struct[dependent_job]].nil?
        process_dependency(@job_struct[dependent_job])
      end
      [@job_struct[dependent_job],dependent_job]
    end
    rescue SystemStackError => e
      # Check that the exception that we are rescuing is the correct one
      if e.message == 'stack level too deep'
        # Raise our own exception for this case
        raise CircularDependencyError, "Jobs can't have circular dependencies"
      else
        # This isn't the exception were looking for, so re-raise
        raise e
      end
    end
  end

end
