import { useBackend } from '../backend';
import { Box, Icon, Stack, Button, Section, NoticeBox, LabeledList, Collapsible } from '../components';
import { Window } from '../layouts';

export const Vote = (props, context) => {
  const { data } = useBackend(context);
  const { mode, question, lower_admin } = data;

  /**
   * Adds the voting type to title if there is an ongoing vote.
   */
  let windowTitle = 'Vote';
  if (mode) {
    windowTitle += ': ' + (question || mode).replace(/^\w/, (c) => c.toUpperCase());
  }

  return (
    <Window resizable title={windowTitle} width={400} height={500}>
      <Window.Content>
        <Stack fill vertical>
          {!!lower_admin && (
            <Section title="Admin Options">
              <VoteOptions />
              <VotersList />
            </Section>
          )}
          <Section title="Start Voting">
            <StartVoteOptions />
          </Section>
          <ChoicesPanel />
          <TimePanel />
        </Stack>
      </Window.Content>
    </Window>
  );
};

const StartVoteOptions = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    allow_vote_mode,
    allow_vote_restart,
    allow_map_voting,
    vote_happening,
  } = data;
  return (
    <Stack.Item>
      <Collapsible title="Start a vote">
        <Stack justify="space-between">
          <Stack.Item>
            <Stack vertical>
              <Stack.Item>
                <Button
                  disabled={vote_happening || !allow_vote_restart}
                  onClick={() => act("restart")}>
                  Restart
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  disabled={vote_happening || !allow_vote_mode}
                  onClick={() => act("gamemode")}>
                  Gamemode
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  disabled={vote_happening || !allow_map_voting}
                  onClick={() => act("next_map")}>
                  Next Map
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Collapsible>
    </Stack.Item>
  );
};

/**
 * The create vote options menu. Only upper admins can disable voting.
 * @returns A section visible to everyone with vote options.
 */
const VoteOptions = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    allow_vote_mode,
    allow_vote_restart,
    allow_map_voting,
    upper_admin,
  } = data;

  return (
    <Stack.Item>
      <Collapsible title="Allow Votes">
        <Stack justify="space-between">
          <Stack.Item>
            <Stack vertical>
              <Stack.Item>
                {!!upper_admin && (
                  <Button.Checkbox
                    mr={!allow_vote_restart ? 1 : 1.6}
                    color="red"
                    checked={!!allow_vote_restart}
                    onClick={() => act("toggle_restart")}>
                    Restart vote is {allow_vote_restart ? "enabled" : "disabled"}
                  </Button.Checkbox>
                )}
              </Stack.Item>
              <Stack.Item>
                {!!upper_admin && (
                  <Button.Checkbox
                    mr={!allow_vote_mode ? 1 : 1.6}
                    color="red"
                    checked={!!allow_vote_mode}
                    onClick={() => act("toggle_gamemode")}>
                    Gamemode vote is {allow_vote_mode ? "enabled" : "disabled"}
                  </Button.Checkbox>
                )}
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack vertical>
              <Stack.Item>
                <Button disabled={!upper_admin} onClick={() => act("custom")}>
                  Create Custom Vote
                </Button>
              </Stack.Item>
              <Stack.Item>
                {!!upper_admin && (
                  <Button.Checkbox
                    mr={!allow_map_voting ? 1 : 1.6}
                    color="red"
                    checked={!!allow_map_voting}
                    onClick={() => act("toggle_next_map")}>
                    Next map vote is {allow_map_voting ? "enabled" : "disabled"}
                  </Button.Checkbox>
                )}
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Collapsible>
    </Stack.Item>
  );
};

/**
 * View Voters by ckey. Admin only.
 * @returns A collapsible list of voters
 */
const VotersList = (props, context) => {
  const { data } = useBackend(context);
  const { voting } = data;

  return (
    <Stack.Item>
      <Collapsible title={`View Voters${voting.length ? `: ${voting.length}` : ""}`}>
        <Section height={8} fill scrollable>
          {voting.map((voter) => {
            return <Box key={voter}>{voter}</Box>;
          })}
        </Section>
      </Collapsible>
    </Stack.Item>
  );
};

/**
 * The choices panel which displays all options in the list.
 * @returns A section visible to all users.
 */
const ChoicesPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const { choices, selected_choice } = data;

  return (
    <Stack.Item grow>
      <Section fill scrollable title="Choices">
        {choices.length !== 0 ? (
          <LabeledList>
            {choices.map((choice, i) => (
              <Box key={choice.id}>
                <LabeledList.Item
                  label={choice.name.replace(/^\w/, (c) => c.toUpperCase())}
                  textAlign="right"
                  buttons={
                    <Button
                      disabled={i === selected_choice - 1}
                      onClick={() => {
                        act('vote', { index: i + 1 });
                      }}>
                      Vote
                    </Button>
                  }>
                  {i === selected_choice - 1 && (
                    <Icon
                      alignSelf="right"
                      mr={2}
                      color="green"
                      name="vote-yea"
                    />
                  )}
                  {choice.votes} Votes
                </LabeledList.Item>
                <LabeledList.Divider />
              </Box>
            ))}
          </LabeledList>
        ) : (
          <NoticeBox>No choices available!</NoticeBox>
        )}
      </Section>
    </Stack.Item>
  );
};

/**
 * Countdown timer at the bottom. Includes a cancel vote option for admins.
 * @returns A section visible to everyone.
 */
const TimePanel = (props, context) => {
  const { act, data } = useBackend(context);
  const { lower_admin, time_remaining } = data;

  return (
    <Stack.Item mt={1}>
      <Section>
        <Stack justify="space-between">
          <Box fontSize={1.5}>Time Remaining: {time_remaining || 0}s</Box>
          {!!lower_admin && (
            <Button
              color="red"
              disabled={!lower_admin}
              onClick={() => act('cancel')}>
              Cancel Vote
            </Button>
          )}
        </Stack>
      </Section>
    </Stack.Item>
  );
};
