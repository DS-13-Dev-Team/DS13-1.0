import { useBackend, useLocalState } from '../backend';
import { Box, Section, Button, Stack, Icon } from '../components';
import { BeakerContents } from "../interfaces/common/BeakerContents";
import { Window } from '../layouts';

export const Grinder = (props, context) => {
  const { act, data } = useBackend(context);
  const [rotation, setRotation] = useLocalState(context, "rotate", 1);
  const {
    processing,
    inuse,
    beakerContents,
    beakerCurrentVolume,
    isBeakerLoaded,
    beakerMaxVolume,
  } = data;

  return (
    <Window
      width={370}
      height={325}>
      <Window.Content>
        <Section title="Grinder">
          {inuse ? (
            <Stack fill vertical>
              <br />
              <Stack.Item align="center">
                <Icon size={13} name="mortar-pestle" />
              </Stack.Item>
              <Stack.Item>
                <Box fontSize={3} textAlign="center">Grinding Reagents</Box>
              </Stack.Item>
            </Stack>
          ):(
            <Box fontSize={1.3}>
              <Stack vertical>
                <Stack.Item>
                  <Stack vertical>
                    <Stack.Item>
                      <Box bold>
                        Processing chamber contains:
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      {processing === 0 ? (
                        <Box color="label">Nothing</Box>
                      ):(
                        <Box>
                          {processing && processing.map((item, e) => <Box key={item} color="label">{item}</Box>)}
                        </Box>
                      )}
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack vertical>
                    <Stack.Item>
                      <Box bold>
                        The beaker contains:
                      </Box>
                    </Stack.Item>
                    <Stack.Item>
                      <BeakerContents
                        beakerLoaded={isBeakerLoaded}
                        beakerContents={beakerContents} />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack vertical>
                    {isBeakerLoaded ? (
                      <>
                        <Stack.Item>
                          <Button disabled={!beakerContents} onClick={() => act('detach')}>
                            Detach the beaker
                          </Button>
                        </Stack.Item>
                        <Stack.Item>
                          <Button disabled={!beakerContents} onClick={() => act('grind')}>
                            Grind
                          </Button>
                        </Stack.Item>
                      </>
                    ):null}
                    {processing ? (
                      <Stack.Item>
                        <Button disabled={!beakerContents} onClick={() => act('eject')}>
                          Eject Reagents
                        </Button>
                      </Stack.Item>
                    ):null}
                  </Stack>
                </Stack.Item>
              </Stack>
            </Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
