import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import { Section, Button, Tabs, Stack, Divider, Box, Input } from '../components';
import { Fragment } from 'inferno';
import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { createSearch } from 'common/string';

export const Store = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    credits_account,
    credits_rig,
    chip,
    chip_worth,
    cash_stored,
    credits_total,
    selected_category,
    categories,
    selected_design_id,
    selected_design_can_afford,
    designs,
    deposit,
  } = data;
  const [
    searchText,
    setSearchText,
  ] = useLocalState(context, 'searchText', '');
  let selected_design;
  let designs_in_category = [];

  designs.forEach(design => {
    if(design.id === selected_design_id) {
      selected_design = design;
    }
    if(selected_category === "All" || design.category === selected_category) {
      designs_in_category.push(design);
    }
  });
  const designs_to_display = flow([
    sortBy(design => design.name),
    filter(createSearch(searchText, design => design.name)),
  ])(designs_in_category);

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
                <Tabs textAlign="center" style={{ "flex-wrap": "wrap" }}>
                  {categories && categories.map((cat, i) => (
                    <Tabs.Tab
                      key={cat}
                      my={0.1}
                      mx={0.1}
                      selected={selected_category === cat}
                      onClick={() => {
                        if (!(selected_category === cat)) {
                          act("category", { "category": cat });
                        }
                      }}>
                      {cat}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              </Stack.Item>
              <Stack.Item grow>
                <Section fill scrollable title="Store Items" buttons={
                  <Input
                    placeholder="Enter design name"
                    value={searchText}
                    width={20}
                    onInput={(e, value) => setSearchText(value)} />
                }>
                  <Stack vertical>
                    {designs_to_display && designs_to_display.map((design, i) => (
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
                      Account: {credits_account} {typeof credits_account === 'number' ?
                        <Button onClick={() => act('withdraw')}>Withdraw</Button> : null}
                    </Stack.Item>
                    <Stack.Item>
                      RIG: {credits_rig}
                    </Stack.Item>
                    <Stack.Item>
                      Chip: {chip ? (<Box>{chip_worth} <Button onClick={() => act('eject_chip')}>Eject Chip</Button></Box>) : "Not Inserted"}
                    </Stack.Item>
                    <Stack.Item>
                      Deposit Cash: {cash_stored}
                    </Stack.Item>
                    <Divider />
                    <Stack.Item>
                      Total Available: {credits_total}
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section fill title="Deposit Box" scrollable buttons={
                  <Button onClick={() => act('eject_all')}>Eject All</Button>
                }>
                  <Stack vertical>
                    {deposit ? deposit.map((item, i) => (
                      <Stack.Item key={item.name}>
                        <Box fontSize={1.2}>{item.name}<Button onClick={() => act("eject", { "item_to_eject": item.name })} ml={1} icon="eject" /></Box>
                      </Stack.Item>
                    )) : (
                      <Box>Deposit box is empty...</Box>
                    )}
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Section fill fontSize={2}>
                  <Stack vertical>
                    <Stack.Item>
                      <Button disabled={!selected_design_can_afford} fluid onClick={() => act("buy", { "buy": 1 })}>Buy</Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button disabled={!selected_design_can_afford} fluid onClick={() => act("buy", { "buy": 2 })}>Buy to Deposit Box</Button>
                    </Stack.Item>
                    {selected_design && selected_design.transfer_enabled && (
                      <Stack.Item>
                        <Button disabled={!selected_design_can_afford} fluid onClick={() => act("buy", { "buy": 3 })}>Buy and Transfer</Button>
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
