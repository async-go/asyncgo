# frozen_string_literal: true

RSpec.describe MarkdownParser, type: :service do
  let(:user) { FactoryBot.create(:user, :team) }
  let(:topic) { FactoryBot.create(:topic, team: user.team) }
  let(:target) { FactoryBot.create(:user, team: user.team) }
  let(:non_target) { FactoryBot.create(:user, team: user.team) }

  describe '#call' do
    subject(:call) { described_class.new(user, text, target).call }

    context 'when mention is not autolinked by the editor' do
      let(:text) { "This is a test for @#{target.email}, but not #{non_target.email}" }

      it 'creates links for mentions' do
        expect(call).to include(
          "<a href=\"mailto:#{target.email}\" target=\"_blank\" rel=\"noopener\">#{target.printable_name}</a>"
        )
      end

      it 'does not create links for mentions without a leading @' do
        expect(call).not_to include(
          "<a href=\"mailto:#{non_target.email}\" target=\"_blank\" rel=\"noopener\">#{non_target.name}</a>"
        )
      end

      it 'builds a notification for the @ mentioned user' do
        expect { call }.to(change { target.notifications.length }.from(0).to(1))
      end

      it 'does not build a notification for the listed (but not @ mentioned) user' do
        expect { call }.not_to(change { non_target.notifications.length })
      end

      context 'when target user is self' do
        let(:target) { user }

        it 'does not create a notification for user' do
          expect { call }.not_to(change { target.notifications.length })
        end
      end
    end

    context 'when mention is already autolinked by the editor' do
      let(:text) do
        <<~MESSAGE
          This is a __bold__ test for @[#{target.printable_name}](#{target.email}),
          but not [#{non_target.printable_name}](#{non_target.email}).
        MESSAGE
      end

      it 'builds a notification for the @ mentioned user' do
        expect { call }.to change { target.notifications.length }.from(0).to(1)
      end

      it 'does not build a notification for the listed (but not @ mentioned) user' do
        expect { call }.not_to(change { non_target.notifications.length })
      end

      context 'when target user is self' do
        let(:target) { user }

        it 'does not create a notification for user' do
          expect { call }.not_to change { target.notifications.length }.from(0)
        end
      end
    end

    context 'when text formatting markdown is provided' do
      let(:text) do
        <<~MESSAGE
          __bold__ _italic_ ~~strikethrough~~

          [Link](https://www.google.com)

          `inline code`

          ```
          code
           block
          ```
        MESSAGE
      end

      it 'renders bold text' do
        expect(call).to include('<strong>bold</strong>')
      end

      it 'renders italic text' do
        expect(call).to include('<em>italic</em>')
      end

      it 'renders strikethrough text' do
        expect(call).to include('<del>strikethrough</del>')
      end

      it 'renders link text' do
        expect(call).to include('<a href="https://www.google.com" target="_blank" rel="noopener">Link</a>')
      end

      it 'renders inline code' do
        expect(call).to include('<code>inline code</code>')
      end

      it 'renders code block' do
        expect(call).to include("<pre><code>code\n block\n</code></pre>")
      end
    end

    context 'when table markdown is provided' do
      let(:text) do
        <<~MESSAGE
          | A | B |
          | --- | --- |
          | C | D |
        MESSAGE
      end

      it 'renders table' do
        expect(call).to include(<<~TABLE
          <table>\n<thead>\n<tr>\n<th>A</th>\n<th>B</th>\n</tr>\n</thead>
          <tbody>\n<tr>\n<td>C</td>\n<td>D</td>\n</tr>\n</tbody>\n</table>
        TABLE
                               )
      end
    end

    context 'when bullet list markdown is provided' do
      let(:text) do
        <<~MESSAGE
          * bullet a

          1. bullet b

          * [ ] bullet c
        MESSAGE
      end

      it 'renders unordered bullet' do
        expect(call).to include("<ul>\n<li>bullet a</li>\n</ul>")
      end

      it 'renders ordered bullet' do
        expect(call).to include("<ol>\n<li>bullet b</li>\n</ol>")
      end

      it 'renders checklist bullet' do
        expect(call).to include("<li>\n<input type=\"checkbox\" disabled> bullet c</li>\n</ul>")
      end
    end

    context 'when header and div markdown are provided' do
      let(:text) do
        <<~MESSAGE
          # Heading 1

          ## Heading 2

          ### Heading 3

          #### Heading 4

          ##### Heading 5

          ###### Heading 6

          - - -
        MESSAGE
      end

      it 'renders h1 text' do
        expect(call).to include('<h1>Heading 1</h1>')
      end

      it 'renders h2 text' do
        expect(call).to include('<h2>Heading 2</h2>')
      end

      it 'renders h3 text' do
        expect(call).to include('<h3>Heading 3</h3>')
      end

      it 'renders h4 text' do
        expect(call).to include('<h4>Heading 4</h4>')
      end

      it 'renders h5 text' do
        expect(call).to include('<h5>Heading 5</h5>')
      end

      it 'renders h6 text' do
        expect(call).to include('<h6>Heading 6</h6>')
      end

      it 'renders hr' do
        expect(call).to include('<hr>')
      end
    end

  end
end
