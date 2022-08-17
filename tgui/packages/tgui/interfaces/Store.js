import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Section, Button, Tabs, Stack, Divider, Box } from '../components';
import { Fragment } from 'inferno';

export const Store = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    credits_account,
    credits_rig,
    chip,
    chip_worth,
    credits_total,
    selected_category,
    categories,
    selected_design,
    designs,
    deposit,
  } = data;
  return (
    <Window
      width={900}
      height={620}
      theme="store">
      <Window.Content>
        <Stack fill>
          <Stack.Item grow basis={0}>
            <Stack vertical fill>
              <Stack.Item>
                <Tabs>
                  <Stack wrap="wrap" textAlign="center">
                    {categories && categories.map((cat, i) => (
                      <Stack.Item key={cat}>
                        <Tabs.Tab
                          key={cat}
                          my={0.5}
                          selected={selected_category === cat}
                          onClick={() => {
                            if (!(selected_category === cat)) {
                              act("category", { "category": cat });
                            }
                          }}>
                          {cat}
                        </Tabs.Tab>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Tabs>
              </Stack.Item>
              <Stack.Item grow>
                <Section fill scrollable title="Store Items">
                  <Stack vertical>
                    {designs && designs.map((design, i) => (
                      <Stack.Item key={design.id}>
                        <Stack>
                          <Stack.Item width="45%">
                            <Button selected={selected_design
                            && design.id === selected_design.id} onClick={() => {
                              if (!(selected_design && design.id === selected_design.id)) {
                                act("select_item", { "select_item": design.id });
                              }
                            }}>
                              {design.name}
                            </Button>
                          </Stack.Item>
                          <Stack.Item>
                            <Box>{design.price}</Box>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item height="21.3%">
                <Section fill scrollable>
                  <Stack>
                    {selected_design ? (
                      <Fragment>
                        <Stack.Item>
                          <Box
                            width={selected_design.icon_width+"px"}
                            height={selected_design.icon_height+"px"}
                            className={"rnd_designs"+selected_design.icon_width+"x"+selected_design.icon_height+" "+selected_design.id} />
                        </Stack.Item>
                        <Stack.Item>
                          <Box bold fontSize={1.8}>{selected_design.name}</Box>
                          <Box fontSize={1.3}>{selected_design.full_desc}</Box>
                        </Stack.Item>
                      </Fragment>
                    ):(
                      <Fragment>
                        <Stack.Item>
                          <Box width="96px" height="96px" />
                        </Stack.Item>
                        <Stack.Item>
                          <Box bold fontSize={1.8}>No item selected</Box>
                          <Box fontSize={1.3}>Select item to see additional information.</Box>
                        </Stack.Item>
                      </Fragment>
                    )}
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack vertical fill>
              <Stack.Item>
                <Section title="Credits">
                  <Stack vertical>
                    <Stack.Item>
                      Account: {credits_account} <Button>Withdraw</Button>
                    </Stack.Item>
                    <Stack.Item>
                      RIG: {credits_rig}
                    </Stack.Item>
                    <Stack.Item>
                      Chip: {chip ? chip_worth : "Not Inserted"}
                    </Stack.Item>
                    <Divider />
                    <Stack.Item>
                      Total Available: {credits_total}
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section fill title="Deposit Box" scrollable>
                  <Stack vertical>
                    {deposit && deposit.map((item, i) => (
                      <Stack.Item key={item}>
                        <Box fontSize={1.2}>{item}<Button onClick={() => act("eject", { "eject": item })} ml={1} icon="eject" /></Box>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Section fill fontSize={2}>
                  <Stack vertical>
                    <Stack.Item>
                      <Button disabled={!selected_design.buy_enabled} fluid onClick={() => act("buy", { "buy": 1 })}>Buy</Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button disabled={!selected_design.buy_enabled} fluid onClick={() => act("buy", { "buy": 2 })}>Buy to Deposit Box</Button>
                    </Stack.Item>
                    {selected_design && selected_design.transfer_enabled && (
                      <Stack.Item>
                        <Button disabled={!selected_design.buy_enabled} fluid onClick={() => act("buy", { "buy": 3 })}>Buy and Transfer</Button>
                      </Stack.Item>
                    )}
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
