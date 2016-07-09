require 'spec_helper'

describe Jobs do
  it 'has a version number' do
    expect(Jobs::VERSION).not_to be nil
  end

  context 'class variables' do
    describe 'Jobs#order' do

      # Given you’re passed an empty string (no jobs), the result should be an empty sequence.
      it 'should pass example 1' do
        job_structure = ''
        expected_output = ''
        expect(Jobs.order(job_structure)).to eq expected_output
      end

      # Given the following job structure:
      #   a =>
      # The result should be a sequence consisting of a single job a.
      it 'should pass example 2' do
        job_structure = { a: nil }
        expected_output = 'a'
        expect(Jobs.order(job_structure)).to eq expected_output
      end

      # Given the following job structure:
      #   a =>
      #   b =>
      #   c =>
      # The result should be a sequence containing all three jobs abc in no significant order.
      it 'should pass example 3' do
        job_structure = {
          a: nil,
          b: nil,
          c: nil
        }
        expected_output = 'abc'
        expect(Jobs.order(job_structure)).to eq expected_output
      end

      # Given the following job structure:
      #   a =>
      #   b => c
      #   c =>
      # The result should be a sequence that positions c before b, containing all three jobs abc.
      it 'should pass example 4' do
        job_structure = {
          a: nil,
          b: :c,
          c: nil
        }
        expected_output = 'acb'
        expect(Jobs.order(job_structure)).to eq expected_output
      end

      # Given the following job structure:
      #   a =>
      #   b => c
      #   c => f
      #   d => a
      #   e => b
      #   f =>
      # The result should be a sequence that positions f before c, c before b, b before e and a before d containing
      # all six jobs abcdef.
      it 'should pass example 5' do
        job_structure = {
          a: nil,
          b: :c,
          c: :f,
          d: :a,
          e: :b,
          f: nil
        }
        expected_output = 'afcbde'
        expect(Jobs.order(job_structure)).to eq expected_output
      end

      # Given the following job structure:
      #   a =>
      #   b =>
      #   c => c
      # The result should be an error stating that jobs can’t depend on themselves.
      it 'should pass example 6' do
        job_structure = {
          a: nil,
          b: nil,
          c: :c
        }
        expect { Jobs.order(job_structure) }.to raise_error(Jobs::DependencyError, "Jobs can't depend on themselves")
      end

      # Given the following job structure:
      #   a =>
      #   b => c
      #   c => f
      #   d => a
      #   e =>
      #   f => b
      # The result should be an error stating that jobs can’t have circular dependencies.
      it 'should pass example 7' do
        job_structure = {
          a: nil,
          b: :c,
          c: :f,
          d: :a,
          e: nil,
          f: :b
        }
        expect(Jobs.order(job_structure)).to raise_error(Jobs::CircularDependencyError,
                                                         "Jobs can't have circular dependencies")
      end

    end
  end

end
