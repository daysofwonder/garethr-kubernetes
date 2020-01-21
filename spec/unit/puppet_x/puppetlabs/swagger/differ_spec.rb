require 'spec_helper'
require 'deep_merge'

require 'kubeclient/resource'
require 'puppet_x/puppetlabs/swagger/differ'

class Hash
  def deep_dup
    Hash[map {|key, value| [key, value.respond_to?(:deep_dup) ? value.deep_dup : begin 
        value.dup
      rescue
        value
      end]}]
  end
end

describe PuppetX::Puppetlabs::Swagger::Differ do
  include PuppetX::Puppetlabs::Swagger::Differ

  def colorized(s)
    colors = {
      :green => "\e[0;32m",
      :red => "\e[0;31m",
      :yellow => "\e[0;33m",
      :reset => "\e[0m"
    }
    s.gsub(/\[(green|red|yellow|reset)\]/) { |r|
      colors[$1.to_sym]
    }
  end

  let(:name) { 'property' }
  let(:a) do
      {
        :template => {
          :metadata => {
            :name => 'hello-world',
            :namespace => 'default',
            :labels => {
              :'app' => 'hello-world'
            },
          },
          :spec => {
            :containers => [{
              :name  => 'trucmuch',
              :image => 'bidule',
              :env => [
                {
                  'name' => 'bidule2',
                  'value' => 'machin3'
                },
              ]
            }]
          }
        }
      }
  end

  it 'returns no diffs doesn\'t return differences' do
    expect(property_diff_with_hashdiff(a, a)).to eq('property didn\'t change')
  end

  it 'formats a key value change' do
    b = {
      :template => {
        :metadata => {
          :name => 'hello-world',
          :namespace => 'changed here',
          :labels => {
            :'app' => 'hello-world'
          },
        },
        :spec => {
          :containers => [{
            :name  => 'trucmuch',
            :image => 'bidule',
            :env => [
              {
                'name' => 'bidule2',
                'value' => 'machin3'
              }
            ]
          }]
        }
      }
    }

    expected = <<~OUTPUT
      property changed with diff:
      {
        template => {
          metadata => {
            name => "hello-world",
          [yellow]~ [reset]namespace => "default" [yellow]~>[reset] "changed here",
            labels => {
              app => "hello-world"
            }
          },
          spec => {
            containers => [
              {
                name => "trucmuch",
                image => "bidule",
                env => [
                  {
                    name => "bidule2",
                    value => "machin3"
                  }
                ]
              }
            ]
          }
        }
      }
    OUTPUT

    expect(property_diff_with_hashdiff(a, b)).to eq(colorized(expected))
  end

  it 'formats a key deletion' do
    b = {
      :template => {
        :metadata => {
          :name => 'hello-world',
          :labels => {
            :'app' => 'hello-world'
          },
        },
        :spec => {
          :containers => [{
            :name  => 'trucmuch',
            :image => 'bidule',
            :env => [
              {
                'name' => 'bidule2',
                'value' => 'machin3'
              }
            ]
          }]
        }
      }
    }

    expected = <<~OUTPUT
      property changed with diff:
      {
        template => {
          metadata => {
            name => "hello-world",
          [red]- [reset]namespace => "default",
            labels => {
              app => "hello-world"
            }
          },
          spec => {
            containers => [
              {
                name => "trucmuch",
                image => "bidule",
                env => [
                  {
                    name => "bidule2",
                    value => "machin3"
                  }
                ]
              }
            ]
          }
        }
      }
    OUTPUT

    expect(property_diff_with_hashdiff(a, b)).to eq(colorized(expected))
  end

  it 'formats a key deletion which is a prefix of another key' do
    b = {
      :template => {
        :metadata => {
          :namespace => 'default',
          :labels => {
            :'app' => 'hello-world'
          },
        },
        :spec => {
          :containers => [{
            :name  => 'trucmuch',
            :image => 'bidule',
            :env => [
              {
                'name' => 'bidule2',
                'value' => 'machin3'
              }
            ]
          }]
        }
      }
    }

    expected = <<~OUTPUT
      property changed with diff:
      {
        template => {
          metadata => {
          [red]- [reset]name => "hello-world",
            namespace => "default",
            labels => {
              app => "hello-world"
            }
          },
          spec => {
            containers => [
              {
                name => "trucmuch",
                image => "bidule",
                env => [
                  {
                    name => "bidule2",
                    value => "machin3"
                  }
                ]
              }
            ]
          }
        }
      }
    OUTPUT

    expect(property_diff_with_hashdiff(a, b)).to eq(colorized(expected))
  end

  it 'formats when adding an array element' do
    b = {
        :template => {
          :metadata => {
            :name => 'hello-world',
            :namespace => 'default',
            :labels => {
              :'app' => 'hello-world'
            },
          },
          :spec => {
            :containers => [{
              :name  => 'trucmuch',
              :image => 'bidule',
              :env => [
                {
                  'name' => 'bidule2',
                  'value' => 'machin3'
                },
                {
                  'name' => 'added',
                  'value' => 'added-too'
                },
              ]
            }]
          }
        }
      }


    expected = <<~OUTPUT
      property changed with diff:
      {
        template => {
          metadata => {
            name => "hello-world",
            namespace => "default",
            labels => {
              app => "hello-world"
            }
          },
          spec => {
            containers => [
              {
                name => "trucmuch",
                image => "bidule",
                env => [
                  {
                    name => "bidule2",
                    value => "machin3"
                  },
                [green]+ [reset]{
                  [green]+ [reset]name => "added",
                  [green]+ [reset]value => "added-too"
                [green]+ [reset]}
                ]
              }
            ]
          }
        }
      }
    OUTPUT
    expect(property_diff_with_hashdiff(a, b)).to eq(colorized(expected))
  end

  it 'formats when adding a simple hash key' do
    b = {
        :template => {
          :metadata => {
            :name => 'hello-world',
            :namespace => 'default',
            :labels => {
              :'app' => 'hello-world'
            },
          },
          :spec => {
            :containers => [{
              :name  => 'trucmuch',
              :image => 'bidule',
              :added => 'really-added',
              :env => [
                {
                  'name' => 'bidule2',
                  'value' => 'machin3'
                }
              ]
            }]
          }
        }
      }


    expected = <<~OUTPUT
      property changed with diff:
      {
        template => {
          metadata => {
            name => "hello-world",
            namespace => "default",
            labels => {
              app => "hello-world"
            }
          },
          spec => {
            containers => [
              {
                name => "trucmuch",
                image => "bidule",
                env => [
                  {
                    name => "bidule2",
                    value => "machin3"
                  }
                ],
              [green]+ [reset]added => "really-added"
              }
            ]
          }
        }
      }
    OUTPUT
    expect(property_diff_with_hashdiff(a, b)).to eq(colorized(expected))
  end

  it 'formats when adding a sub hash' do
    b = {
        :template => {
          :metadata => {
            :name => 'hello-world',
            :namespace => 'default',
            :labels => {
              :'app' => 'hello-world'
            },
            :annotations => {
              :added => :toto
            }
          },
          :spec => {
            :containers => [{
              :name  => 'trucmuch',
              :image => 'bidule',
              :env => [
                {
                  'name' => 'bidule2',
                  'value' => 'machin3'
                }
              ]
            }]
          }
        }
      }


    expected = <<~OUTPUT
      property changed with diff:
      {
        template => {
          metadata => {
            name => "hello-world",
            namespace => "default",
            labels => {
              app => "hello-world"
            },
          [green]+ [reset]annotations => {
            [green]+ [reset]added => "toto"
          [green]+ [reset]}
          },
          spec => {
            containers => [
              {
                name => "trucmuch",
                image => "bidule",
                env => [
                  {
                    name => "bidule2",
                    value => "machin3"
                  }
                ]
              }
            ]
          }
        }
      }
    OUTPUT
    expect(property_diff_with_hashdiff(a, b)).to eq(colorized(expected))
  end


  it 'formats when adding an array in a new hash key' do
    b = {
        :template => {
          :metadata => {
            :name => 'hello-world',
            :namespace => 'default',
            :labels => {
              :'app' => 'hello-world'
            },
          },
          :spec => {
            :containers => [{
              :name  => 'trucmuch',
              :image => 'bidule',
              :volumes => [{
                :name => 'vol1',
                :path => '/mnt/vol1'
              }],
              :env => [
                {
                  'name' => 'bidule2',
                  'value' => 'machin3'
                }
              ]
            }]
          }
        }
      }


    expected = <<~OUTPUT
      property changed with diff:
      {
        template => {
          metadata => {
            name => "hello-world",
            namespace => "default",
            labels => {
              app => "hello-world"
            }
          },
          spec => {
            containers => [
              {
                name => "trucmuch",
                image => "bidule",
                env => [
                  {
                    name => "bidule2",
                    value => "machin3"
                  }
                ],
              [green]+ [reset]volumes => [
                [green]+ [reset]{
                  [green]+ [reset]name => "vol1",
                  [green]+ [reset]path => "/mnt/vol1"
                [green]+ [reset]}
              [green]+ [reset]]
              }
            ]
          }
        }
      }
    OUTPUT
    expect(property_diff_with_hashdiff(a, b)).to eq(colorized(expected))
  end


  it 'formats when remove a sub hash' do
    b = {
        :template => {
          :metadata => {
            :name => 'hello-world',
            :namespace => 'default',
          },
          :spec => {
            :containers => [{
              :name  => 'trucmuch',
              :image => 'bidule',
              :env => [
                {
                  'name' => 'bidule2',
                  'value' => 'machin3'
                }
              ]
            }]
          }
        }
      }


    expected = <<~OUTPUT
      property changed with diff:
      {
        template => {
          metadata => {
            name => "hello-world",
            namespace => "default",
          [red]- [reset]labels => {
            [red]- [reset]app => "hello-world"
          [red]- [reset]}
          },
          spec => {
            containers => [
              {
                name => "trucmuch",
                image => "bidule",
                env => [
                  {
                    name => "bidule2",
                    value => "machin3"
                  }
                ]
              }
            ]
          }
        }
      }
    OUTPUT
    expect(property_diff_with_hashdiff(a, b)).to eq(colorized(expected))
  end

  it 'formats when remove an array element' do
    b = {
        :template => {
          :metadata => {
            :name => 'hello-world',
            :namespace => 'default',
            :labels => {
              :'app' => 'hello-world'
            },
          },
          :spec => {
            :containers => [{
              :name  => 'trucmuch',
              :image => 'bidule',
              :env => [
              ]
            }]
          }
        }
      }


    expected = <<~OUTPUT
      property changed with diff:
      {
        template => {
          metadata => {
            name => "hello-world",
            namespace => "default",
            labels => {
              app => "hello-world"
            }
          },
          spec => {
            containers => [
              {
                name => "trucmuch",
                image => "bidule",
                env => [
                [red]- [reset]{
                  [red]- [reset]name => "bidule2",
                  [red]- [reset]value => "machin3"
                [red]- [reset]}
                ]
              }
            ]
          }
        }
      }
    OUTPUT
    expect(property_diff_with_hashdiff(a, b)).to eq(colorized(expected))
  end

  it 'formats when remove an array element' do
    a = {
      :template => {
        :spec => {
          :containers => [
            {
              :name => 'hello-world'
            }
          ]
        }
      }
    }
    b = {
    }


    expected = <<~OUTPUT
      property changed with diff:
      {
      [red]- [reset]template => {
        [red]- [reset]spec => {
          [red]- [reset]containers => [
            [red]- [reset]{
              [red]- [reset]name => "hello-world"
            [red]- [reset]}
          [red]- [reset]]
        [red]- [reset]}
      [red]- [reset]}
      }
    OUTPUT
    expect(property_diff_with_hashdiff(a, b)).to eq(colorized(expected))
  end

end