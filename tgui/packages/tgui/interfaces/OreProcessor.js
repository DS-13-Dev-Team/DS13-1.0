import { useBackend } from '../backend';
import { Section, Box, LabeledList, Dropdown, Stack, Button, AnimatedNumber } from '../components';
import { Window } from '../layouts';

export const OreProcessor = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    ores,
    active,
    panel_status,
  } = data;

  // ORDER IS IMPORTANT HERE.
  const processingOptions = [
    "Not Processing",
    "Smelting",
    "Compressing",
    "Alloying",
  ];

  return (
    <Window
      width={400}
      height={510}>
      <Window.Content>
        <Section title="Ore Processor Console" fill>
          <Box fontSize={1.3}>
            <LabeledList>
              {ores && ores.map((ore, i) => (
                <Stack justify="space-between" fill key={ore.type}>
                  <Stack.Item>
                    <LabeledList.Item label={ore.name}>
                      <AnimatedNumber value={ore.amount} />
                    </LabeledList.Item>
                  </Stack.Item>
                  <Stack.Item>
                    <Dropdown
                      selected={processingOptions[ore.processing]}
                      options={processingOptions}
                      color={
                        ore.processing === 0 && 'red'
                        || ore.processing === 1 && 'orange'
                        || ore.processing === 2 && 'green'
                        || ore.processing === 3 && 'yellow'
                      }
                      my={0.3}
                      noscroll
                      width={14}
                      onSelected={value => act("toggle_smelting", { ore_type: ore.type, tog_smelt: processingOptions.indexOf(value) })} />
                  </Stack.Item>
                </Stack>
              ))}
            </LabeledList>
            <br />
            {panel_status ? (
              <Box textColor="red">
                Close Maintenance Panel before activating Ore Processor!
              </Box>
            ):null}
            <Stack>
              <Stack.Item>
                <Box>
                  The ore processor is currently:
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Button.Checkbox fluid checked={active}
                  onClick={() => act("activate")}>
                  {active ? (
                    "Enabled"
                  ):(
                    "Disabled"
                  )}
                </Button.Checkbox>
              </Stack.Item>
            </Stack>
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
