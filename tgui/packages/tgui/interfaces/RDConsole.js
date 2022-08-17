import { Component } from 'inferno';
import { useBackend, useSharedState } from '../backend';
import { Box, AnimatedNumber, Button, LabeledList, ProgressBar, Section, Stack, Tabs, Icon, Divider, Flex, Tooltip, NoticeBox, Grid } from '../components';
import { Window } from '../layouts';
import { round } from 'common/math';
import { Fragment } from 'inferno';
import { KEY_1, KEY_2, KEY_3, KEY_4, KEY_RIGHT, KEY_LEFT } from 'common/keycodes';

export const RDConsole = (props, context) => {
  const { data, act } = useBackend(context);

  const {
    locked,
    lathe_data,
    lathe_all_cats,
    lathe_possible_designs,
    lathe_queue_data,
    lathe_cat,
    imprinter_data,
    imprinter_possible_designs,
    imprinter_all_cats,
    imprinter_queue_data,
    imprinter_cat,
    has_protolathe,
    has_imprinter,
    console_tab,
    can_research,
  } = data;

  return (
    <Window
      width={1000}
      height={800}
      theme="rdconsole">
      {!locked ? (
        <Window.Content
          onKeyPress={e => {
            if (e.keyCode === KEY_1) {
              act("change_tab", { "machine": 4, "tab": 4 });
            }
            if (e.keyCode === KEY_2) {
              act("change_tab", { "machine": 4, "tab": 3 });
            }
            if (e.keyCode === KEY_3) {
              act("change_tab", { "machine": 4, "tab": 2 });
            }
            if (e.keyCode === KEY_4) {
              act("change_tab", { "machine": 4, "tab": 1 });
            }
          }}
          onKeyDown={e => {
            if (e.keyCode === KEY_RIGHT) {
              act("change_design_cat_arrow", { "dir": "right", "machine": console_tab });
            }
            if (e.keyCode === KEY_LEFT) {
              act("change_design_cat_arrow", { "dir": "left", "machine": console_tab });
            }
          }}>
          <Tabs textAlign="center">
            <Tabs.Tab
              selected={console_tab === 4}
              onClick={() => {
                if (!(console_tab === 4)) {
                  act("change_tab", { "machine": 4, "tab": 4 });
                }
              }}>
              Main
            </Tabs.Tab>
            {can_research ? (
              <Tabs.Tab
                selected={console_tab === 3}
                onClick={() => {
                  if (!(console_tab === 3)) {
                    act("change_tab", { "machine": 4, "tab": 3 });
                  }
                }}>
                Research
              </Tabs.Tab>
            ):null}
            {has_protolathe ? (
              <Tabs.Tab
                selected={console_tab === 2}
                disabled={!has_protolathe}
                onClick={() => {
                  if (!(console_tab === 2)) {
                    act("change_tab", { "machine": 4, "tab": 2 });
                  }
                }}>
                Protolathe
              </Tabs.Tab>
            ):null}
            {has_imprinter ? (
              <Tabs.Tab
                selected={console_tab === 1}
                disabled={!has_imprinter}
                onClick={() => {
                  if (!(console_tab === 1)) {
                    act("change_tab", { "machine": 4, "tab": 1 });
                  }
                }}>
                Circuit Imprinter
              </Tabs.Tab>
            ):null}
          </Tabs>
          {console_tab === 4 && (
            <MainTab />
          )}
          {console_tab === 3 && (
            <Research />
          )}
          {console_tab === 2 && (
            <MachineTab title="Protolathe"
              machine_data={lathe_data}
              possible_designs={lathe_possible_designs}
              queue_data={lathe_queue_data}
              all_cats={lathe_all_cats}
              current_cat={lathe_cat} />
          )}
          {console_tab === 1 && (
            <MachineTab title="Circuit Imprinter"
              machine_data={imprinter_data}
              possible_designs={imprinter_possible_designs}
              queue_data={imprinter_queue_data}
              all_cats={imprinter_all_cats}
              current_cat={imprinter_cat} />
          )}
        </Window.Content>
      ):(
        <Window.Content>
          <LockedScreen />
        </Window.Content>
      )}
    </Window>
  );
};

const LockedScreen = (props, context) => {
  const { act } = useBackend(context);

  return (
    <Section fill textAlign="center">
      <NoticeBox mt="2.5%" className="sciLocked" fontSize={6}>SYSTEM LOCKED</NoticeBox>
      <br />
      <Button
        fontSize={4}
        icon="unlock-alt"
        onClick={() => act("lock")}>
        Unlock
      </Button>
    </Section>
  );
};

const MainTab = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    sync,
    has_protolathe,
    has_imprinter,
    has_destroy,
  } = data;

  return (
    <Stack vertical fill height="95%">
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Section fill title="Settings">
              <Stack vertical>
                <Stack.Item>
                  <Button
                    icon="sync"
                    disabled={!sync}
                    tooltip="Synchronizes technologies and designs with connected server."
                    tooltipPosition="bottom-start"
                    onClick={() => act("sync")}>
                    Sync Database with Network
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button.Checkbox
                    checked={sync}
                    onClick={() => act("togglesync")}
                    icon="lightbulb">
                    Connection to Research Network
                  </Button.Checkbox>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="lock"
                    tooltip="Locks console to prevent unauthorized use."
                    tooltipPosition="bottom-start"
                    onClick={() => act("lock")}>
                    Lock Console
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act("resync_machines")} icon="link">
                    Re-sync with Nearby Devices
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button disabled={!has_protolathe} onClick={() => act("disconnect", { machine: 2 })} icon="times">
                    Disconnect Protolathe
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button disabled={!has_imprinter} onClick={() => act("disconnect", { machine: 1 })} icon="times">
                    Disconnect Circuit Imprinter
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button disabled={!has_destroy} onClick={() => act("disconnect", { machine: 3 })} icon="times">
                    Disconnect Destructive Analyzer
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow basis={0}>
            <TechLevelsInfo />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item grow basis={0}>
        <DestructiveAnalyzer />
      </Stack.Item>
    </Stack>
  );
};

const DestructiveAnalyzer = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    has_destroy,
    destroy_data,
  } = data;

  return (
    <Section fill title="Destructive Analyzer">
      {has_destroy ? (
        <Box>
          {destroy_data.loading_item ? (
            <Box textAlign="center">
              <Icon mt={4} name="spinner" size={18} spin />
              <Box fontSize={7} mt={2.3}>Item is being loaded</Box>
            </Box>
          ):(
            <Box>
              {destroy_data.has_item ? (
                <Box>
                  {destroy_data.is_processing ? (
                    <Box textAlign="center">
                      <Icon mt={4} name="spinner" size={18} spin />
                      <Box fontSize={6}>Item is being deconstructed</Box>
                    </Box>
                  ):(
                    <Stack vertical fontSize={1.3}>
                      <Stack.Item pr={3}>
                        <Stack>
                          <Stack.Item>
                            <img src={"da_"+destroy_data.icon_path+".png"} class="sciDeconIcon" />
                          </Stack.Item>
                          <Stack.Item width="80%">
                            <Stack vertical>
                              <Stack.Item bold>
                                {destroy_data.item_name}
                              </Stack.Item>
                              <Stack.Item>
                                <Box>
                                  {destroy_data.item_desc}
                                </Box>
                              </Stack.Item>
                            </Stack>
                          </Stack.Item>
                          <Stack.Item ml={3}>
                            <Stack vertical>
                              <Stack.Item>
                                <Button icon="eject" fluid fontSize={2.3} onClick={() => act('eject_decon')}>Eject Item</Button>
                              </Stack.Item>
                              <Stack.Item>
                                <Button icon="atom" fluid fontSize={2.3} onClick={() => act('deconstruct')}>Deconstruct Item</Button>
                              </Stack.Item>
                            </Stack>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                      <Stack.Item px={3}>
                        <Stack vertical>
                          {destroy_data.tech_data
                            && destroy_data.tech_data.map((tech, i) => (
                              <Stack.Item key={tech.id}>
                                <ProgressBar minValue={0}
                                  value={tech.level}
                                  maxValue={20}>
                                  <Stack justify="space-between">
                                    <Stack.Item>
                                      {tech.name}
                                    </Stack.Item>
                                    <Stack.Item>
                                      {tech.level}
                                    </Stack.Item>
                                  </Stack>
                                </ProgressBar>
                              </Stack.Item>
                            ))}
                        </Stack>
                      </Stack.Item>
                      <Stack.Item px={3}>
                        <Box inline fontSize={1.7} bold>Research points:</Box> <Box fontSize={1.7} inline color="orange">{destroy_data.item_tech_points} points</Box>
                      </Stack.Item>
                      <Stack.Item px={3}>
                        <Box inline fontSize={1.7} bold>Research value:</Box> <Box fontSize={1.7} inline color="orange">{destroy_data.item_tech_mod}%</Box>
                      </Stack.Item>
                    </Stack>
                  )}
                </Box>
              ):(
                <Box align="center">
                  <Icon mt={6} name="low-vision" size={18} />
                  <Box fontSize={8}>No item loaded</Box>
                </Box>
              )}
            </Box>
          )}
        </Box>
      ):(
        <Box textAlign="center" textColor="red">
          <Icon name="unlink" color="white" size={20} mt={3} />
          <Box fontSize={6}>
            No Destructive Analyzer Linked
          </Box>
        </Box>
      )}
    </Section>
  );
};

const TechLevelsInfo = (props, context) => {
  const { data } = useBackend(context);

  const {
    tech_trees,
  } = data;

  return (
    <Section fill title="Technology Research">
      <LabeledList>
        {tech_trees && tech_trees.map((tech_tree, i) => (
          <LabeledList.Item key={tech_tree.name} labelColor="white" label={tech_tree.shortname}>
            <ProgressBar
              minValue={0}
              maxValue={tech_tree.maxlevel}
              value={tech_tree.level}>
              {tech_tree.level}/{tech_tree.maxlevel}
            </ProgressBar>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const Research = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    selected_tech,
  } = data;

  return (
    <Stack vertical fill height="95%">
      <Stack.Item height="75%">
        <TechTree />
      </Stack.Item>
      <Stack.Item grow>
        {selected_tech?(
          <Section fill title={selected_tech.name} buttons={
            <Box bold fontSize="14px"> Cost: <Box inline color="orange">{selected_tech.cost}</Box></Box>
          }>
            <Stack fill>
              <Stack.Item width="45%" mr={2}>
                <Stack>
                  <Stack.Item>
                    <div class={"rdtech96x96 "+selected_tech.id} />
                  </Stack.Item>
                  <Stack.Item>
                    {selected_tech.desc}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item width="23.5%">
                <Box bold>
                  Unlocks Designs:
                </Box>
                {selected_tech.unlocks_design
                && selected_tech.unlocks_design.map((design, i) => (
                  <Box key={design}>
                    <Box color="#27f2eb">{design}</Box>
                  </Box>
                ))}
              </Stack.Item>
              <Stack.Item width="20%">
                <Box bold>
                  Required Technology:
                </Box>
                {selected_tech.req_techs_unlock
                && selected_tech.req_techs_unlock.map((req_tech, i) => (
                  <Box key={req_tech}>
                    <Box color="lime">{req_tech}</Box>
                  </Box>
                ))}
                {selected_tech.req_techs_lock
                && selected_tech.req_techs_lock.map((req_tech, i) => (
                  <Box key={req_tech}>
                    <Box color="red">{req_tech}</Box>
                  </Box>
                ))}
              </Stack.Item>
              <Stack.Item width="25%">
                <Button
                  fluid
                  disabled={selected_tech.isresearched || selected_tech.canresearch}
                  fontSize={2.4}
                  textAlign="center"
                  onClick={() => act('research_tech', { tech_id: selected_tech.id })}>
                  {selected_tech.isresearched ? "Researched" : "Research"}
                </Button>
              </Stack.Item>
            </Stack>
          </Section>
        ):(
          <Section fill title="No Technology Selected" />
        )}
      </Stack.Item>
    </Stack>
  );
};

const MachineTab = (props, context) => {
  const { act } = useBackend(context);
  const {
    title,
    machine_data,
    possible_designs,
    queue_data,
    all_cats,
    current_cat,
  } = props;
  const [materialReagent, setMaterialReagent] = useSharedState(context, props.machine_data.machine_id+"_materialReagent", 0);

  return (
    <Stack justify="space-between" height="95%">
      <Stack.Item grow basis={0}>
        <Stack vertical fill>
          <Stack.Item>
            <Tabs>
              <Stack wrap="wrap" textAlign="center">
                {all_cats && all_cats.map((category, i) => (
                  <Stack.Item key={category}>
                    <Tabs.Tab
                      my={0.5}
                      selected={current_cat === category}
                      onClick={() => {
                        if (!(current_cat === category)) {
                          act("change_tab", { "machine": machine_data.machine_id, "tab": category });
                        } }}>
                      {category}
                    </Tabs.Tab>
                  </Stack.Item>
                ))}
              </Stack>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill title={title+" Menu"} scrollable>
              <Flex direction="column">
                <Divider />
                {possible_designs
                  && possible_designs.map((design, i) => (
                    <Fragment key={design.id}>
                      {design.category === current_cat ? (
                        <Flex.Item>
                          <Stack justify="space-between">
                            <Stack.Item width="55%">
                              <Flex>
                                <Flex.Item mb={-6} mr={-4}>
                                  <Box className={"rnd_designs"+design.icon_width+"x"+design.icon_height+" "+design.id+" sciScale64"} />
                                </Flex.Item>
                                <Flex.Item>
                                  {design.name}
                                  <br />
                                  <Box color="label" position="relative">
                                    {design.full_desc ? (
                                      <Tooltip content={design.full_desc} position="bottom">
                                        <Box>{design.desc}</Box>
                                      </Tooltip>
                                    ):(
                                      <Box>
                                        {design.desc}
                                      </Box>
                                    )}
                                  </Box>
                                </Flex.Item>
                              </Flex>
                            </Stack.Item>
                            <Stack.Item grow>
                              <Flex vertical>
                                <Flex.Item>
                                  {design.can_create >= 5 && (
                                    <Button
                                      icon="wrench"
                                      onClick={() => act("build",
                                        { "id": design.id,
                                          "machine": machine_data.machine_id,
                                          "amount": 1 })}>
                                      Build
                                    </Button>
                                  )}
                                </Flex.Item>
                                <Flex.Item>
                                  {design.can_create >= 5 && (
                                    <Button
                                      mx={0.3}
                                      onClick={() => act("build",
                                        { "id": design.id,
                                          "machine": machine_data.machine_id,
                                          "amount": 5 })}>
                                      x5
                                    </Button>
                                  )}
                                </Flex.Item>
                                <Flex.Item>
                                  {design.can_create >= 10 && (
                                    <Button
                                      onClick={() => act("build",
                                        { "id": design.id,
                                          "machine": machine_data.machine_id,
                                          "amount": 10 })}>
                                      x10
                                    </Button>
                                  )}
                                </Flex.Item>
                              </Flex>
                            </Stack.Item>
                            <Stack.Item mr={1} textAlign="right" width="19.5%">
                              {design.mats && design.mats.map((mat, i) => (
                                <Box key={mat.name} textColor={mat.can_make ? "white":"red"}>
                                  {mat.amount} {mat.name}
                                </Box>
                              ))}
                              {design.chems && design.chems.map((chem, i) => (
                                <Box key={chem.name} textColor={chem.can_make ? "white":"red"}>
                                  {chem.amount} {chem.name}
                                </Box>
                              ))}
                            </Stack.Item>
                          </Stack>
                          <Divider />
                        </Flex.Item>
                      ):null}
                    </Fragment>
                  ))}
              </Flex>
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item width="43.4%">
        <Stack vertical fill>
          <Stack.Item height="38%">
            {materialReagent === 0 ?(
              <MachineMaterialsTab machine_data={machine_data} title={title+" Material Storage"} />
            ):(
              <MachineReagentsTab machine_data={machine_data} title={title+" Reagent Storage"} />
            )}
          </Stack.Item>
          <Stack.Item height="62%">
            <Section title="Queue" scrollable fill style={{ "overflow": "hidden" }} buttons={
              <Fragment>
                <Button onClick={() => act("clear_queue", { "machine": machine_data.machine_id })}>
                  Clear Queue
                </Button>
                <Button onClick={() => act("restart_queue", { "machine": machine_data.machine_id })}>
                  Restart Queue
                </Button>
              </Fragment>
            }>
              <LabeledList>
                {queue_data
                  && queue_data.map((queue, i) => (
                    <LabeledList.Item label={queue.name} key={queue.item}>
                      <Button onClick={() => act("remove_from_queue", { "machine": machine_data.machine_id, "queue_item": queue.item })}>
                        Remove
                      </Button>
                    </LabeledList.Item>
                  ))}
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const MachineMaterialsTab = (props, context) => {
  const { act } = useBackend(context);

  const {
    machine_data,
    title,
  } = props;

  const [materialReagent, setMaterialReagent] = useSharedState(context, props.machine_data.machine_id+"_materialReagent");

  return (
    <Section title={title} fill buttons={<Button icon="chevron-right" iconPosition="right" onClick={() => setMaterialReagent(1)}>Reagent Storage</Button>}>
      <LabeledList>
        <LabeledList.Item labelColor="white" label="Total Materials">
          <ProgressBar
            minValue={0}
            maxValue={machine_data.max_material_storage}
            value={machine_data.total_materials}>
            <AnimatedNumber value={machine_data.total_materials} /> cm³/
            {machine_data.max_material_storage} cm³
          </ProgressBar>
        </LabeledList.Item>
        {machine_data.materials
          && machine_data.materials.map((material, i) => (
            <LabeledList.Item key={material.name} labelColor="orange" label={material.name} buttons={
              <Fragment>
                {material.amount >= 2000 ? (
                  <Button onClick={() => act("eject", { machine: machine_data.machine_id, id: material.id, amount: 1 })} mx={0.5}>
                    Eject x1
                  </Button>
                ):null}
                {material.amount >= 10000 ? (
                  <Button onClick={() => act("eject", { machine: machine_data.machine_id, id: material.id, amount: 5 })}>
                    Eject x5
                  </Button>
                ):null}
                {material.amount >= 2000 ? (
                  <Button.Input
                    maxValue={round(parseInt(material.amount,
                      10)/2000)}
                    value={1}
                    content={"Eject [Max:"+round(parseInt(material.amount,
                      10)/2000)+"]"}
                    onCommit={(e, value) => act('eject', {
                      id: material.id,
                      machine: machine_data.machine_id,
                      amount: value })} />
                ):null}
              </Fragment>
            }>
              <Box inline><AnimatedNumber value={material.amount} /> cm³</Box>
            </LabeledList.Item>
          ))}
      </LabeledList>
    </Section>
  );
};

const MachineReagentsTab = (props, context) => {
  const { act } = useBackend(context);

  const {
    machine_data,
    title,
  } = props;

  const [materialReagent, setMaterialReagent] = useSharedState(context, props.machine_data.machine_id+"_materialReagent");

  return (
    <Section title={title} fill buttons={<Button icon="chevron-right" iconPosition="right" onClick={() => setMaterialReagent(0)}>Material Storage</Button>}>
      <LabeledList>
        <LabeledList.Item labelColor="white" label="Total Reagents">
          <ProgressBar
            minValue={0}
            maxValue={machine_data.maximum_volume}
            value={machine_data.total_volume}>
            <AnimatedNumber value={machine_data.total_volume}
            />u/{machine_data.maximum_volume}u
          </ProgressBar>
        </LabeledList.Item>
        {machine_data.reagents
          && machine_data.reagents.map((reagent, i) => (
            <LabeledList.Item key={reagent.name} labelColor="orange" label={reagent.name} buttons={
              <Fragment>
                <Button onClick={() => act("purge", { machine: machine_data.machine_id, type: reagent.type, volume: 1 })} mx={0.5}>
                  Purge 1u
                </Button>
                {reagent.volume >= 5 ? (
                  <Button onClick={() => act("purge", { machine: machine_data.machine_id, type: reagent.type, volume: 5 })} mx={0.5}>
                    Purge 5u
                  </Button>
                ):null}
                <Button.Input
                  maxValue={round(parseInt(reagent.volume,
                    10))}
                  value={1}
                  content={"Purge [Max: "+round(parseInt(reagent.volume,
                    10))+"]"}
                  onCommit={(e, value) => act('purge', {
                    type: reagent.type,
                    machine: machine_data.machine_id,
                    volume: value })} />
              </Fragment>
            }>
              <AnimatedNumber value={reagent.volume} />u
            </LabeledList.Item>
          ))}
      </LabeledList>
    </Section>
  );
};

/*
 *  RnD Tech Tree
 */

const pauseEvent = e => {
  if (e.stopPropagation) { e.stopPropagation(); }
  if (e.preventDefault) { e.preventDefault(); }
  e.cancelBubble = true;
  e.returnValue = false;
  return false;
};

export class TechTree extends Component {
  constructor(props) {
    super(props);

    this.state = {
      offsetX: 0,
      offsetY: 0,
      transform: 'none',
      dragging: false,
      originX: null,
      originY: null,
    };

    // Dragging
    this.handleDragStart = e => {
      this.ref = e.target;
      this.setState({
        dragging: false,
        originX: e.screenX,
        originY: e.screenY,
      });
      document.addEventListener('mousemove', this.handleDragMove);
      document.addEventListener('mouseup', this.handleDragEnd);
      pauseEvent(e);
    };

    this.handleDragMove = e => {
      this.setState(prevState => {
        const state = { ...prevState };
        const newOffsetX = e.screenX - state.originX;
        const newOffsetY = e.screenY - state.originY;
        if (prevState.dragging) {
          state.offsetX += newOffsetX;
          state.offsetY += newOffsetY;
          state.originX = e.screenX;
          state.originY = e.screenY;
        } else {
          state.dragging = true;
        }
        return state;
      });
      pauseEvent(e);
    };

    this.handleDragEnd = e => {
      this.setState({
        dragging: false,
        originX: null,
        originY: null,
      });
      document.removeEventListener('mousemove', this.handleDragMove);
      document.removeEventListener('mouseup', this.handleDragEnd);
      pauseEvent(e);
    };

  }

  render() {
    const { dragging } = this.state;
    const { data, act } = useBackend(this.context);
    const {
      columns,
      rows,
      tech_trees,
      techs,
      lines,
      research_points,
      selected_tech,
      tech_cat,
    } = data;

    return (
      <Section
        fill
        style={{ "overflow": "hidden", "-ms-scroll-limit": "0 0 0 0", "cursor": dragging ? "move" : "auto" }}
        // Makes tech trees draggable. Don't need it right now
        // Enable it if you want to make REALLY big tech tree
        // onMouseDown={this.handleDragStart}
        title="Research Menu"
        buttons={<Box bold fontSize="14px">Research Points: <Box inline color="orange">{research_points}</Box></Box>}>
        <Tabs textAlign="center">
          {tech_trees && tech_trees.map((tech_tree, i) => (
            <Tabs.Tab
              key={tech_tree.id}
              selected={tech_tree.id === tech_cat}
              onClick={() => {
                if (!(tech_tree.id === tech_cat)) {
                  act("change_tab", { "machine": 3, "tab": tech_tree.id });
                  this.setState({ "offsetY": 0, "offsetX": 0 });
                } }}>
              {tech_tree.shortname}
            </Tabs.Tab>
          ))}
        </Tabs>
        <Box style={{ "overflow": "hidden", "-ms-scroll-limit": "0 0 0 0" }}>
          <Grid columns={columns} rows={rows} gridSize="18px">
            {lines && lines.map((line, i) => (
              <Grid.Item
                key={i}
                firstColumn={line.height_1}
                firstRow={line.width_1}
                secondColumn={line.height_2}
                secondRow={line.width_2}
                className={
                  (line.bottom && "sciBorderBottom ") + (line.left && " sciBorderLeft ") + (line.right && " sciBorderRight ") + (line.top && " sciBorderTop")
                } />
            ))}
            {techs && techs.map((tech, i) => (
              <Grid.Item
                key={tech.id}
                firstColumn={tech.x}
                firstRow={tech.y}
                secondColumn={1}
                secondRow={1}>
                <Button
                  position="absolute"
                  p={0}
                  width="36px"
                  height="36px"
                  color={(selected_tech && tech.id===selected_tech.id?"caution":(tech.isresearched?"selected":(tech.canresearch?"default":"danger")))}
                  tooltip={
                    <Box>
                      {tech.name}
                      <br />
                      {tech.desc}
                    </Box>
                  }
                  tooltipPosition="bottom-start"
                  onDblClick={() => act('research_tech', { tech_id: tech.id })}
                  onClick={() => act('set_selected_tech', { tech_id: tech.id })}>
                  <Box mt="2px" ml="2px" className={"rdtech96x96 "+tech.id+" sciScale32"} />
                </Button>
              </Grid.Item>
            ))}
          </Grid>
        </Box>
      </Section>
    );
  }
}
